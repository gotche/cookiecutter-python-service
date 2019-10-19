install_requirements: 
	pip install -r requirements-dev.base

update_requirements:
	pip freeze > requirements-dev.txt

test:
	pytest
