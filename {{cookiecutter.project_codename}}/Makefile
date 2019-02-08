test:
	pytest -vv -s

coverage:
	coverage run --source $$PROJECT_CODENAME -m pytest
	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

install_dev_env:
	PROJECT_CODENAME={{cookiecutter.project_codename}} ./tools/install_dev_env.sh

update_requirements_files:
	pur -r requirements.txt -r requirements-dev.txt

edit_env_vars:
	ansible-vault edit sensitive-env-vars
	direnv allow .
