#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MSYS" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

go build hello.go
./hello.exe
