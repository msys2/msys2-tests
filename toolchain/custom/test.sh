#!/bin/bash

set -e

# https://github.com/msys2/MINGW-packages/issues/11553
# https://github.com/msys2/MINGW-packages/pull/12042
# binutils strip seems to break libc++
if command -v clang++ >/dev/null 2>&1; then
    command -v lld >/dev/null
    clang++ test-libc++-static.cc -stdlib=libc++ -static -fuse-ld=lld -o test.exe
    ./test.exe
    rm test.exe
fi
