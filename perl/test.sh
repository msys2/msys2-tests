#!/bin/bash

set -e

if [[ "$MSYSTEM" == "CLANG32" || "$MSYSTEM" == "MINGW32" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

perl hello.pl
