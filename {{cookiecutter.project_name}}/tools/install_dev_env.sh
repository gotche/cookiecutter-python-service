#!/bin/bash

CODENAME=$PROJECT_CODENAME
PYTHON_VERSION="3.7.4"
PYTHON_FAMILY="python3.7"

{% if cookiecutter.use_pyenv == 'y' %}
# Use pyenv to handle virtual envs
if ! [ -x "$(command -v pyenv)" ]; then
    echo "Please install pyenv: https://github.com/pyenv/pyenv#installation"
    exit 1
fi

if [ -e .python-version ]; then
    echo "Found .python-version. Using it as virtualenv"
else
    echo "Creating a virtualenv"
    pyenv install $PYTHON_VERSION -s
    pyenv virtualenv -p $PYTHON_FAMILY $PYTHON_VERSION $CODENAME
    echo "Activating virtualenv"
    pyenv local $CODENAME
fi
{% endif %}

# Install dev requirements
pip install -r requirements-dev.txt

# Initialize git repo
git init

# Install pre-commit hooks using the pre-commit framework
pre-commit install

# Use direnv for sensitive env vars
if ! [ -x "$(command -v direnv)" ]; then
    echo "Please install direnv: sudo apt install direnv"
    exit 1
fi

if [[ -z "${ANSIBLE_VAULT_PASSWORD_FILE}" ]]; then
    echo "Adding ANSIBLE_VAULT_PASSWORD_FILE env var to .bashrc"
    echo "export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.pass" >> ~/.bashrc
    export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.pass
    echo "Don't forget to populate the pass file"

if [ ! -f "$ANSIBLE_VAULT_PASSWORD_FILE" ]; then
    strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'> ~/.ansible_vault.pass
    exit 1
fi

direnv allow

{% if cookiecutter.use_database == 'postgresql9.6' %}
# Populate env vars for development

# Install database
docker run --name {{cookiecutter.project_codename}} -e POSTGRES_USER=$DB_USER_LOCAL -e POSTGRES_DB=$DB_NAME_LOCAL -p $DB_PORT_LOCAL:$DB_PORT_LOCAL -d postgres:9.6-alpine
docker start $DB_NAME_LOCAL
{% endif %}
