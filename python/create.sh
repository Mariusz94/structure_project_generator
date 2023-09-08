#!/bin/bash

script_path="$(readlink -f "$0")"
directory_name="$(dirname "$script_path")"
folder_name="$(basename "$directory_name")"
project_name="$folder_name"
echo "$folder_name"

# Bieżąca ścieżka
directory_path="$PWD"

# Definiujemy zawartość pliku launch.json z komentarzami
launch_json_content='{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "cwd": "${fileDirname}",
            "console": "integratedTerminal",
            "justMyCode": true
        }
    ]
}'

# Zapisujemy zawartość do pliku launch.json
echo "$launch_json_content" > "$directory_path/.vscode/launch.json"

# Informacja o zakończeniu
echo "Utworzono folder .vscode i plik launch.json"

mkdir -p "$directory_path/app/"
mkdir -p "$directory_path/app/grpc_file/"
mkdir -p "$directory_path/app/service/logs_service"
app_logs_content='import logging
import config


def init_logging() -> None:
    """
    Konfiguracja logera.

    Returns:
        None
    """
    logging.basicConfig(
        level=getattr(logging, config.LOGGING_MODE),
        format="%(asctime)s.%(msecs)03d-%(levelname)s-%(funcName)s()-%(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )
    logging.info("SET UP FINISHED\n")


def config_logs() -> None:
    """
    Logi pojawiające się przy uruchomieniu mikroserwisu.

    Returns:
        None
    """
    logging.info(f"{config.SERVICE_NAME=}")
    logging.info(f"{config.MS_VERSION=}")
    logging.info(f"{config.SERVICE_PORT=}")
    logging.info(f"{config.LOGGING_MODE=}")
    logging.info("\n")
'

echo "$app_logs_content" > "$directory_path/app/service/logs_service/app_logs.py"

# Informacja o zakończeniu
echo "Utworzono strukturę katalogów i plik app_logs.py"


config_content='import os
from dotenv import load_dotenv

load_dotenv()


"""
Plik konfiguracyjny.
"""

SERVICE_NAME = "'"$project_name"'"
"""Nazwa mikroserwisu."""

MS_VERSION = str(os.environ.get("MS_VERSION", "NOT AVAILABLE"))
"""Wersja mikroserwisu."""

SERVICE_PORT = int(os.environ.get("SERVICE_PORT", 80))
"""Port, na którym dostępny jest serwis."""

LOGGING_MODE = str(os.environ.get("LOGGING_MODE", "DEBUG"))
"""Poziom logowania informacji, błędów."""'

echo "$config_content" > "$directory_path/app/config.py"

# Informacja o zakończeniu
echo "Utworzono plik config.py"


requirements_content='python-dotenv==1.0.0

grpcio==1.50.0
grpcio-tools==1.50.0'

path="$directory_path/app/requirements.txt"

echo "$requirements_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"


server_content='import config
from service.logs_service.app_logs import config_logs, init_logging


if __name__ == "__main__":
    init_logging()
    config_logs()
'

path="$directory_path/app/server.py"

echo "$server_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"


mkdir -p "$directory_path/docker/"
dockerfile_content='FROM python:3.8-slim
ARG GITHUB_RUN_NUMBER


COPY app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt


WORKDIR /app
COPY app/ .

CMD ["python", "-u", "server.py"]'

path="$directory_path/docker/Dockerfile"

echo "$dockerfile_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"


mkdir -p "$directory_path/docs/"
conf_content="# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
import os,sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../app')))
sys.path.append(r'../app/grpcfile')

project = '$project_name'
copyright = '2023, Dream team'
author = 'Dream team'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = ['sphinx.ext.todo','sphinx.ext.viewcode','sphinx.ext.autodoc','sphinx.ext.napoleon']

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
latex_elements = {
    'papersize': 'a4paper',         # Format papieru (np. a4paper, letterpaper)
    'classoptions': ',oneside',    # Opcje klasy dokumentu, 'oneside' to jednostronny dokument
    'preamble': r'''
      \usepackage[columns=1]{idxlayout}
    ''' # 1 kolumna w index
}
"

path="$directory_path/docs/conf.py"

echo "$conf_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"


index_content=".. $project_name documentation master file, created by
   sphinx-quickstart on Sat Jul 29 19:37:03 2023.
   You can adapt this file completely to your liking, but it should at least
   contain the root \`toctree\` directive.

Welcome to $project_name's documentation!
=====================================================

.. toctree::
   :maxdepth: 99
   :caption: Contents:

   modules

Indices and tables
==================

* :ref:\`genindex\`
* :ref:\`modindex\`
* :ref:\`search\`
"

path="$directory_path/docs/index.rst"

echo "$index_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"


doc_makefile_content='# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)


install:
	pip install -U sphinx
	pip install sphinx-rtd-theme

setup:
	sphinx-quickstart

doc:
	find . -name "*.rst" ! -name "index.rst" -exec rm {} \;
	sphinx-apidoc -o . ../app 
	make clean
	make html
	make latexpdf
	cp ./_build/latex/'"$project_name"'.pdf ./../'"$project_name"'.pdf
'

path="$directory_path/docs/Makefile"

echo "$doc_makefile_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"

mkdir -p "$directory_path/tests/"

context_content='import os
import sys
# Dodanie katalogu projektu do ścieżek testów 
# NIE ZMIENIAĆ
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../app")))'

path="$directory_path/tests/context.py"

echo "$context_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"


mkdir -p "$directory_path/tests/functional_tests"

init_content='import os
import sys
# Dodanie katalogu projektu do ścieżek testów 
# NIE ZMIENIAĆ
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../app")))'

path="$directory_path/tests/functional_tests/__init__.py"

echo "$init_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"


mkdir -p "$directory_path/tests/unit_tests"

path="$directory_path/tests/unit_tests/__init__.py"

echo "$init_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"


gitignore_content='# Byte-compiled / optimized / DLL files
__pycache__/
.pytest_cache

# Sphinx documentation
docs/*
!/docs/conf.py
!/docs/index.rst
!/docs/Makefile
'

path="$directory_path/.gitignore"

echo "$gitignore_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"


makefile_content='doc:
    make -C ./docs doc
'

path="$directory_path/Makefile"

echo "$makefile_content" > "$path"

# Informacja o zakończeniu
echo "Utworzono plik $path"