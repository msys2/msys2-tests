#!/bin/bash

set -e

if [[ "$MSYSTEM" == "CLANG32" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

CC=${CC:-cc} python setup.py build_ext --force --inplace
python test.py
