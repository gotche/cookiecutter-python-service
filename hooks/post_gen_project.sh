#!/bin/bash

echo "DUMMY=1" > sensitive-env-vars
ansible-vault encrypt sensitive-env-vars
