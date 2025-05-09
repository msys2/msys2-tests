#!/bin/bash

set -e

if [[ "$MSYSTEM" == "CLANG32" || "$MSYSTEM" == "MSYS" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

if [[ "$MSYSTEM" == "UCRT64" && "$CC" == "clang" ]]; then
    echo "skipped on $MSYSTEM with clang"
    exit 0;
fi

FC="${FC:-gfortran}"

"$FC" --version
"$FC" hello.f90 -o hello.exe
./hello.exe
