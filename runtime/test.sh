#!/bin/bash

set -e

if [[ "$MSYSTEM" != "MSYS" ]]; then
    echo "skipped not on $MSYSTEM"
    exit 0;
fi

/opt/bin/x86_64-w64-mingw32-gcc -municode echo.c -o echo.exe

python test.py