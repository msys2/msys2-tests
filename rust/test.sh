#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MSYS" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

rustc hello.rs
./hello.exe