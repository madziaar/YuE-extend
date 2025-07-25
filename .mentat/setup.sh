#!/bin/bash

# Install git-lfs (needed for model downloads)
git lfs install

# Install Python dependencies
pip3 install -r requirements.txt

# Install common Python development tools for formatting
pip3 install black isort ruff
