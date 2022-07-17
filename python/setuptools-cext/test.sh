#!/bin/bash

set -e

CC=${CC:-cc} python setup.py build_ext --force --inplace
python test.py
