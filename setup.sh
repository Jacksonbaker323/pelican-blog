#!/bin/bash

virtualenv . &&
source bin/activate
pip install -r requirements.txt &&
git submodule update --init --recursive &&
pelican-themes -i themes/attila
