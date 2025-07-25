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

# Configuration
PYTHON_FILES_PATTERN="**/*.py"
EXCLUDE_PATTERNS=("build/" "dist/" "*.egg-info/" "__pycache__/" ".git/" "workspace/")
DRY_RUN=false
VERBOSE=false

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                log_info "Running in dry-run mode"
                shift
                ;;
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Format and lint Python code in the repository.

OPTIONS:
    --dry-run    Show what would be changed without making changes
    --verbose    Show detailed output
    --help       Show this help message

TOOLS USED:
    - black: Code formatting
    - isort: Import sorting
    - ruff: Fast linting and additional formatting
    - mypy: Type checking (if available)

EOF
}

# Ensure required tools are available
ensure_tools() {
    local missing_tools=()
    local tools=("black" "isort" "ruff")
    
    log_info "Checking for required formatting tools..."
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        elif [[ "$VERBOSE" == "true" ]]; then
            version=$($tool --version 2>/dev/null | head -n1 || echo "unknown")
            log_info "$tool found: $version"
        fi
    done
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_warning "Missing tools: ${missing_tools[*]}"
        log_info "Installing missing formatting tools..."
        
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "Would install: ${missing_tools[*]}"
        else
            python3 -m pip install "${missing_tools[@]}"
            log_success "Installed missing tools"
        fi
    else
        log_success "All required tools are available"
    fi
}

# Build exclude arguments for isort (uses different format)
build_isort_exclude_args() {
    local exclude_patterns=""
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ -n "$exclude_patterns" ]]; then
            exclude_patterns="$exclude_patterns,$pattern"
        else
            exclude_patterns="$pattern"
        fi
    done
    if [[ -n "$exclude_patterns" ]]; then
        echo "--skip-glob $exclude_patterns"
    fi
}

# Build exclude arguments for ruff
build_ruff_exclude_args() {
    local exclude_patterns=""
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ -n "$exclude_patterns" ]]; then
            exclude_patterns="$exclude_patterns,$pattern"
        else
            exclude_patterns="$pattern"
        fi
    done
    if [[ -n "$exclude_patterns" ]]; then
        echo "--exclude $exclude_patterns"
    fi
}

# Format imports with isort
format_imports() {
    log_info "Sorting imports with isort..."
    
    local cmd="isort"
    local exclude_args=$(build_isort_exclude_args)
    
    if [[ "$DRY_RUN" == "true" ]]; then
        cmd="$cmd --check-only --diff"
    fi
    
    if [[ "$VERBOSE" == "true" ]]; then
        cmd="$cmd --verbose"
    fi
    
    # Use configuration from pyproject.toml if available
    if [[ -f "pyproject.toml" ]]; then
        cmd="$cmd --settings-path=pyproject.toml"
    fi
    
    if [[ -n "$exclude_args" ]]; then
        eval "$cmd $exclude_args ." || {
            if [[ "$DRY_RUN" == "true" ]]; then
                log_warning "Import sorting issues found (dry-run mode)"
            else
                log_error "Failed to sort imports"
                return 1
            fi
        }
    else
        eval "$cmd ." || {
            if [[ "$DRY_RUN" == "true" ]]; then
                log_warning "Import sorting issues found (dry-run mode)"
            else
                log_error "Failed to sort imports"
                return 1
            fi
        }
    fi
    
    log_success "Import sorting completed"
}

# Format code with black
format_code() {
    log_info "Formatting code with black..."
    
    local cmd="black"
    local exclude_args=""
    
    # Build exclude pattern for black
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ -n "$exclude_args" ]]; then
            exclude_args="$exclude_args|$pattern"
        else
            exclude_args="$pattern"
        fi
    done
    
    if [[ -n "$exclude_args" ]]; then
        cmd="$cmd --extend-exclude '($exclude_args)'"
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        cmd="$cmd --check --diff"
    fi
    
    if [[ "$VERBOSE" == "true" ]]; then
        cmd="$cmd --verbose"
    fi
    
    eval "$cmd ." || {
        if [[ "$DRY_RUN" == "true" ]]; then
            log_warning "Code formatting issues found (dry-run mode)"
        else
            log_error "Failed to format code"
            return 1
        fi
    }
    
    log_success "Code formatting completed"
}

# Lint and fix with ruff
lint_and_fix() {
    log_info "Linting and fixing with ruff..."
    
    local exclude_args=$(build_ruff_exclude_args)
    
    # First, run ruff check with fixes
    local check_cmd="ruff check"
    if [[ "$DRY_RUN" != "true" ]]; then
        check_cmd="$check_cmd --fix"
    fi
    
    if [[ "$VERBOSE" == "true" ]]; then
        check_cmd="$check_cmd --verbose"
    fi
    
    if [[ -n "$exclude_args" ]]; then
        eval "$check_cmd $exclude_args ." || {
            log_warning "Some linting issues found (may not be auto-fixable)"
        }
    else
        eval "$check_cmd ." || {
            log_warning "Some linting issues found (may not be auto-fixable)"
        }
    fi
    
    # Then run ruff format
    local format_cmd="ruff format"
    if [[ "$DRY_RUN" == "true" ]]; then
        format_cmd="$format_cmd --check --diff"
    fi
    
    if [[ -n "$exclude_args" ]]; then
        eval "$format_cmd $exclude_args ." || {
            if [[ "$DRY_RUN" == "true" ]]; then
                log_warning "Ruff formatting issues found (dry-run mode)"
            else
                log_error "Failed to format with ruff"
                return 1
            fi
        }
    else
        eval "$format_cmd ." || {
            if [[ "$DRY_RUN" == "true" ]]; then
                log_warning "Ruff formatting issues found (dry-run mode)"
            else
                log_error "Failed to format with ruff"
                return 1
            fi
        }
    fi
    
    log_success "Linting and formatting with ruff completed"
}

# Optional type checking with mypy
type_check() {
    if command -v mypy &> /dev/null; then
        log_info "Running type checking with mypy..."
        
        local cmd="mypy"
        if [[ "$VERBOSE" == "true" ]]; then
            cmd="$cmd --verbose"
        fi
        
        # Use configuration from pyproject.toml if available
        if [[ -f "pyproject.toml" ]]; then
            cmd="$cmd --config-file=pyproject.toml"
        fi
        
        eval "$cmd ." || {
            log_warning "Type checking found issues (not blocking)"
        }
        
        log_success "Type checking completed"
    else
        log_info "mypy not available, skipping type checking"
    fi
}

# Generate summary report
generate_summary() {
    log_info "Generating formatting summary..."
    
    # Count Python files
    local python_files=$(find . -name "*.py" -not -path "./build/*" -not -path "./dist/*" -not -path "./.git/*" -not -path "./workspace/*" | wc -l)
    
    log_info "Python files processed: $python_files"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "This was a dry-run. No files were modified."
        log_info "Run without --dry-run to apply the changes."
    else
        log_success "All formatting tasks completed successfully!"
    fi
}

# Main execution function
main() {
    log_info "Starting code formatting and linting..."
    
    parse_args "$@"
    ensure_tools
    
    # Run formatting tools in order
    format_imports
    format_code
    lint_and_fix
    
    # Optional type checking
    if [[ "$VERBOSE" == "true" ]]; then
        type_check
    fi
    
    generate_summary
    
    log_success "Code formatting process completed!"
}

# Run main function with all arguments
main "$@"
