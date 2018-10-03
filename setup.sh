#!/bin/bash

virtualenv . &&
pip install -r requirements.txt &&
git submodule update --init --recursive &&
pelican-themes -i themes/attila
