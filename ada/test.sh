#!/bin/bash

set -e

if [[ "$MSYSTEM" == CLANG* || "$MSYSTEM" == "MINGW32" || "$MSYSTEM" == "MSYS" || "$CC" == "clang" ]]; then
    echo "skipped on $MSYSTEM with $CC"
    exit 0;
fi

gnatmake --version

gnatmake hello.adb
./hello.exe

gnatmake gnat_exception_internal.adb
./gnat_exception_internal.exe
