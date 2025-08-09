#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MSYS" || "$MSYSTEM" == "CLANG32" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

rustc --version
rustc hello.rs
./hello.exe