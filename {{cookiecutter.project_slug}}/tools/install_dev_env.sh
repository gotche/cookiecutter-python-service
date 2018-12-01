#!/bin/bash

{% if cookiecutter.use_pyenv == 'y' -%}
# Use pyenv to handle virtual envs
if ! [ -x "$(command -v pyenv)" ]; then
    echo "Please install pyenv: https://github.com/pyenv/pyenv#installation"
    exit 1
fi

if [ -e .python-version ]; then
    echo "Found .python-version. Using it as virtualenv"
else
    echo "Creating a virtualenv"
    pyenv virtualenv -p python3.7 3.7.1 {{cookiecutter.project_slug}}
    echo "Activating virtualenv"
    pyenv local {{cookiecutter.project_slug}}
fi
{%- endif %}

# Install dev requirements
pip install -r requirements-dev.txt

# Install pre-commit hooks using the pre-commit framework
pre-commit install
