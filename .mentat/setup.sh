#!/bin/bash

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check Python version compatibility
check_python_version() {
    log_info "Checking Python version compatibility..."
    python_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    required_version="3.9"
    
    if python3 -c "import sys; exit(0 if sys.version_info >= (3, 9) else 1)"; then
        log_success "Python ${python_version} is compatible (>= ${required_version})"
    else
        log_error "Python ${python_version} is not compatible. Required: >= ${required_version}"
        exit 1
    fi
}

# Install git-lfs if not already installed
setup_git_lfs() {
    log_info "Setting up Git LFS..."
    if command -v git-lfs &> /dev/null; then
        git lfs install
        log_success "Git LFS configured successfully"
    else
        log_warning "Git LFS not found in PATH, attempting to install..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y git-lfs
        elif command -v yum &> /dev/null; then
            sudo yum install -y git-lfs
        elif command -v brew &> /dev/null; then
            brew install git-lfs
        else
            log_error "Cannot install git-lfs automatically. Please install manually."
            exit 1
        fi
        git lfs install
        log_success "Git LFS installed and configured"
    fi
}

# Upgrade pip and install core packages
setup_pip() {
    log_info "Upgrading pip and installing core packages..."
    # Try to upgrade pip, but don't fail if system packages conflict
    python3 -m pip install --upgrade --user pip || {
        log_warning "Could not upgrade pip (system package conflicts), continuing..."
    }
    
    # Try to install/upgrade setuptools and wheel with --user to avoid conflicts
    python3 -m pip install --user setuptools wheel || {
        log_warning "Could not install setuptools/wheel, continuing with system versions..."
    }
    
    log_success "Pip setup completed"
}

# Install Python dependencies with better error handling
install_python_deps() {
    log_info "Installing Python dependencies from requirements.txt..."
    if [[ -f "requirements.txt" ]]; then
        # Install requirements with --user to avoid system conflicts
        python3 -m pip install --user -r requirements.txt || {
            log_warning "Some dependencies failed to install, trying without --user flag..."
            python3 -m pip install -r requirements.txt || {
                log_error "Failed to install dependencies from requirements.txt"
                log_info "You may need to install some dependencies manually"
            }
        }
        log_success "Python dependencies installation completed"
    else
        log_warning "requirements.txt not found, skipping Python dependencies"
    fi
}

# Install development tools with pinned versions for consistency
install_dev_tools() {
    log_info "Installing development tools..."
    
    # Install formatting and linting tools, trying --user first to avoid conflicts
    dev_tools=(
        "black>=24.0.0"
        "isort>=5.12.0" 
        "ruff>=0.1.0"
        "mypy>=1.0.0"
        "pre-commit>=3.0.0"
        "pytest>=7.0.0"
        "pytest-cov>=4.0.0"
    )
    
    for tool in "${dev_tools[@]}"; do
        python3 -m pip install --user "$tool" || {
            log_warning "Failed to install $tool with --user, trying system install..."
            python3 -m pip install "$tool" || {
                log_warning "Failed to install $tool, skipping..."
            }
        }
    done
    
    log_success "Development tools installation completed"
}

# Create development configuration files
create_dev_configs() {
    log_info "Creating development configuration files..."
    
    # Create pyproject.toml if it doesn't exist
    if [[ ! -f "pyproject.toml" ]]; then
        cat > pyproject.toml << 'EOF'
[tool.black]
line-length = 88
target-version = ['py39']
include = '\.pyi?$'
extend-exclude = '''
/(
  # Exclude auto-generated files
  \.eggs
  | \.git
  | \.hg
  | \.mypy_cache
  | \.tox
  | \.venv
  | _build
  | buck-out
  | build
  | dist
  | workspace
)/
'''

[tool.isort]
profile = "black"
multi_line_output = 3
line_length = 88
known_first_party = ["yue"]
known_third_party = ["torch", "transformers", "numpy", "scipy"]

[tool.ruff]
line-length = 88
target-version = "py39"
select = [
    "E",  # pycodestyle errors
    "W",  # pycodestyle warnings
    "F",  # pyflakes
    "I",  # isort
    "B",  # flake8-bugbear
    "C4", # flake8-comprehensions
    "UP", # pyupgrade
]
ignore = [
    "E501",  # line too long (handled by black)
    "B008",  # do not perform function calls in argument defaults
    "B905",  # zip() without an explicit strict= parameter
]
exclude = [
    ".git",
    "__pycache__",
    "build",
    "dist",
    "workspace",
    "*.egg-info",
]

[tool.ruff.per-file-ignores]
"__init__.py" = ["F401"]  # Allow unused imports in __init__.py

[tool.mypy]
python_version = "3.9"
warn_return_any = true
warn_unused_configs = true
ignore_missing_imports = true
exclude = [
    "build/",
    "dist/",
    "workspace/",
]
EOF
        log_success "Created pyproject.toml with tool configurations"
    fi
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."
    
    # Check that key tools are available
    tools=("black" "isort" "ruff")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            version=$($tool --version 2>/dev/null | head -n1 || echo "unknown")
            log_success "$tool is available: $version"
        else
            log_warning "$tool is not available in PATH"
        fi
    done
    
    # Test Python imports for key dependencies (non-blocking)
    log_info "Testing key Python imports..."
    python3 -c "
import sys
packages = ['torch', 'transformers', 'numpy', 'scipy', 'tqdm']
failed = []
success = []
for pkg in packages:
    try:
        __import__(pkg)
        print(f'✓ {pkg}')
        success.append(pkg)
    except ImportError:
        print(f'✗ {pkg} (missing or not properly installed)')
        failed.append(pkg)

print(f'Successfully imported: {len(success)} packages')
if failed:
    print(f'Failed to import: {failed}')
    print('Note: Some ML dependencies may require special installation procedures.')
    print('Please refer to the project README for specific dependency installation instructions.')
else:
    print('All key packages imported successfully')
" || {
        log_warning "Some Python imports failed - this may be expected in some environments"
    }
    
    log_success "Installation verification completed"
}

main() {
    log_info "Starting YuE development environment setup..."
    
    check_python_version
    setup_git_lfs
    setup_pip
    install_python_deps
    install_dev_tools
    create_dev_configs
    verify_installation
    
    log_success "Development environment setup completed successfully!"
    log_info "You can now run the format script to apply code formatting standards."
}

# Run main function
main "$@"
