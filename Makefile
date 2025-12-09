.PHONY: all setup clean docker-build
VENV := .venv
PY := $(VENV)/bin/python
PIP := $(VENV)/bin/pip


all: setup


setup:
python3 -m venv $(VENV)
$(PIP) install --upgrade pip
$(PIP) install -r requirements.txt


clean:
rm -rf $(VENV) reports .pytest_cache


docker-build:
docker-compose build
