#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MSYS" ]] || [[ "$MSYSTEM" == "CLANG32" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

go version
go build hello.go
./hello.exe

go build cgo.go
./cgo.exe

# https://github.com/msys2/MINGW-packages/issues/18166
[ -n "$(go env GOPROXY)" ] || (echo "error: GOPROXY not set"; exit 1)