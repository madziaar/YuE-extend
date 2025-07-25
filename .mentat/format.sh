#!/bin/bash

# Install formatting tools if not available
if ! command -v black &> /dev/null || ! command -v isort &> /dev/null || ! command -v ruff &> /dev/null; then
    echo "Installing formatting tools..."
    pip3 install black isort ruff
fi

# Format Python code with black
black .

# Sort imports with isort
isort .

# Fix linting issues with ruff
ruff check --fix .

# Format again with ruff formatter
ruff format .
