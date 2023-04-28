#!/bin/bash

set -e

if [[ "$MSYSTEM" == CLANG* || "$MSYSTEM" == "MSYS" || "$CC" == "clang" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

gnatmake hello.adb
./hello.exe
