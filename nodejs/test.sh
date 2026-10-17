#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MSYS" || "$MSYSTEM" == "CLANG32" || "$MSYSTEM" == "MINGW32" || "$MSYSTEM" == "MINGW64" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

node --version
node hello.mjs