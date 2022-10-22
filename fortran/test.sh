#!/bin/bash

set -e

if [[ "$MSYSTEM" == "CLANG32" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

FC="${FC:-gfortran}"

"$FC" hello.f90 -o hello.exe
./hello.exe
