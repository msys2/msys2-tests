#!/bin/bash

set -e

# build the library
cd mylib
make -j DESTDIR="$(pwd)/dest" install

# test the build result
test -f "$(pwd)/dest/lib/libmylib.a"
test -f "$(pwd)/dest/lib/libmylib.dll.a"
test -f "$(pwd)/dest/include/mylib.h"
if [[ "$MSYSTEM" != "MSYS" ]]; then
    test -f "$(pwd)/dest/bin/libmylib-42.dll"
else
    test -f "$(pwd)/dest/bin/msys-mylib-42.dll"
fi
