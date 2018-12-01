test:
	pytest -vv -s

coverage:
	coverage run --source {{ cookiecutter.project_slug }} -m pytest
	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

install_dev_env:
	./tools/install_dev_env.sh

update_requirements_files:
	pur -r requirements.txt -r requirements-dev.txt
