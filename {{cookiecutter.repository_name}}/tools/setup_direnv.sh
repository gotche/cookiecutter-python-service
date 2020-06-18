#!/bin/bash


# Use direnv for sensitive env vars
if ! [ -x "$(command -v direnv)" ]; then
    echo "Please install direnv: sudo apt install direnv"
    exit 1
fi

{% if cookiecutter.use_vault== 'n' %}
if [[ -z "${ANSIBLE_VAULT_PASSWORD_FILE}" ]]; then
    echo "Adding ANSIBLE_VAULT_PASSWORD_FILE env var to .bashrc"
    echo "export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.pass" >> ~/.bashrc
    export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault.pass
    echo "Don't forget to populate the pass file"
fi

if [ ! -f "$ANSIBLE_VAULT_PASSWORD_FILE" ]; then
    strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'> ~/.ansible_vault.pass
    exit 1
fi
{% endif %}

direnv allow
