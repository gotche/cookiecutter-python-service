#!/bin/bash

CODENAME=$PROJECT_CODENAME

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
    pyenv virtualenv -p python3.7 3.7.2 $CODENAME
    echo "Activating virtualenv"
    pyenv local $CODENAME
fi
{%- endif %}

# Install dev requirements
pip install -r requirements-dev.txt

# Install pre-commit hooks using the pre-commit framework
pre-commit install

# Use direnv for sensitive env vars
if ! [ -x "$(command -v direnv)" ]; then
    echo "Please install direnv: sudo apt install direnv"
    exit 1
fi

if [[ -z "${ANSIBLE_VAULT_PASSWORD_FILE}" ]]; then
    echo "Please set the team vault password in a file in "
    echo "your filesystem and then add this to your .bashrc"
    echo "export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.pass"
    echo "Don't forget to populate the pass file"
    exit 1
fi

direnv allow
