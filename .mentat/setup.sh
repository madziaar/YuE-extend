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
    python3 -m pip install --upgrade pip setuptools wheel
    log_success "Core pip packages upgraded"
}

# Install Python dependencies with better error handling
install_python_deps() {
    log_info "Installing Python dependencies from requirements.txt..."
    if [[ -f "requirements.txt" ]]; then
        # Use pip-tools if available for better dependency resolution
        if python3 -m pip install pip-tools &> /dev/null; then
            python3 -m pip install -r requirements.txt --upgrade
        else
            python3 -m pip install -r requirements.txt
        fi
        log_success "Python dependencies installed successfully"
    else
        log_warning "requirements.txt not found, skipping Python dependencies"
    fi
}

# Install development tools with pinned versions for consistency
install_dev_tools() {
    log_info "Installing development tools..."
    
    # Install formatting and linting tools with specific versions for consistency
    python3 -m pip install \
        black>=24.0.0 \
        isort>=5.12.0 \
        ruff>=0.1.0 \
        mypy>=1.0.0 \
        pre-commit>=3.0.0 \
        pytest>=7.0.0 \
        pytest-cov>=4.0.0
    
    log_success "Development tools installed successfully"
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
    tools=("black" "isort" "ruff" "mypy")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            version=$($tool --version 2>/dev/null | head -n1 || echo "unknown")
            log_success "$tool is available: $version"
        else
            log_warning "$tool is not available in PATH"
        fi
    done
    
    # Test Python imports for key dependencies
    log_info "Testing key Python imports..."
    python3 -c "
import sys
packages = ['torch', 'transformers', 'numpy', 'scipy', 'tqdm']
failed = []
for pkg in packages:
    try:
        __import__(pkg)
        print(f'✓ {pkg}')
    except ImportError:
        print(f'✗ {pkg}')
        failed.append(pkg)

if failed:
    print(f'Warning: Failed to import: {failed}')
    sys.exit(1)
else:
    print('All key packages imported successfully')
"
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
