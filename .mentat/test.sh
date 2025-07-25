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
COVERAGE_THRESHOLD=80
TEST_PATTERN="test_*.py"
EXCLUDE_PATTERNS=("build/" "dist/" "*.egg-info/" "__pycache__/" ".git/" "workspace/")

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --coverage)
                RUN_COVERAGE=true
                shift
                ;;
            --threshold)
                COVERAGE_THRESHOLD="$2"
                shift 2
                ;;
            --pattern)
                TEST_PATTERN="$2"
                shift 2
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

Run tests for the YuE project with optional coverage reporting.

OPTIONS:
    --coverage           Run tests with coverage reporting
    --threshold NUM      Set coverage threshold (default: $COVERAGE_THRESHOLD)
    --pattern PATTERN    Test file pattern (default: $TEST_PATTERN)
    --help              Show this help message

EXAMPLES:
    $0                              # Run basic tests
    $0 --coverage                   # Run tests with coverage
    $0 --coverage --threshold 90    # Run tests with 90% coverage threshold

EOF
}

# Check if pytest is available
check_pytest() {
    if ! command -v pytest &> /dev/null; then
        log_warning "pytest not found, installing..."
        python3 -m pip install pytest pytest-cov pytest-xdist
        log_success "pytest installed"
    fi
}

# Run basic tests
run_tests() {
    log_info "Running tests..."
    
    # Find test files
    local test_files=$(find . -name "$TEST_PATTERN" -not -path "./build/*" -not -path "./dist/*" -not -path "./workspace/*" | wc -l)
    
    if [[ $test_files -eq 0 ]]; then
        log_warning "No test files found matching pattern: $TEST_PATTERN"
        log_info "Creating basic test structure..."
        create_test_structure
        return 0
    fi
    
    log_info "Found $test_files test files"
    
    # Run pytest with appropriate options
    local pytest_args=("-v" "--tb=short")
    
    if [[ "${RUN_COVERAGE:-false}" == "true" ]]; then
        pytest_args+=(
            "--cov=src"
            "--cov-report=term-missing"
            "--cov-report=html:coverage_html"
            "--cov-fail-under=$COVERAGE_THRESHOLD"
        )
    fi
    
    python3 -m pytest "${pytest_args[@]}" || {
        log_error "Tests failed"
        return 1
    }
    
    log_success "Tests completed successfully"
}

# Create basic test structure if none exists
create_test_structure() {
    log_info "Creating basic test structure..."
    
    mkdir -p tests
    
    # Create a basic test file
    cat > tests/test_basic.py << 'EOF'
"""Basic tests for YuE project."""

import sys
from pathlib import Path

# Add src to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))


def test_imports():
    """Test that we can import key modules."""
    try:
        import numpy as np
        import torch
        assert True
    except ImportError as e:
        assert False, f"Failed to import required packages: {e}"


def test_python_version():
    """Test that we're running on Python 3.9+."""
    assert sys.version_info >= (3, 9), f"Python 3.9+ required, got {sys.version_info}"


def test_basic_functionality():
    """Test basic functionality."""
    # Add basic functionality tests here
    assert 1 + 1 == 2  # Placeholder test
EOF
    
    # Create pytest configuration
    cat > pytest.ini << 'EOF'
[tool:pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = 
    --strict-markers
    --strict-config
    --disable-warnings
markers =
    slow: marks tests as slow (deselect with '-m "not slow"')
    integration: marks tests as integration tests
    unit: marks tests as unit tests
EOF
    
    log_success "Created basic test structure in tests/ directory"
    log_info "You can now add your own tests to the tests/ directory"
}

# Generate test report
generate_report() {
    log_info "Generating test report..."
    
    if [[ "${RUN_COVERAGE:-false}" == "true" && -d "coverage_html" ]]; then
        log_success "Coverage report generated in coverage_html/"
        log_info "Open coverage_html/index.html in your browser to view detailed coverage"
    fi
    
    log_success "Test execution completed!"
}

# Main execution function
main() {
    log_info "Starting test execution..."
    
    parse_args "$@"
    check_pytest
    run_tests
    generate_report
    
    log_success "Test process completed!"
}

# Run main function with all arguments
main "$@"
