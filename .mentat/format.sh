#!/bin/bash

# Format Python code with black
black .

# Sort imports with isort
isort .

# Fix linting issues with ruff
ruff check --fix .

# Format again with ruff formatter
ruff format .
