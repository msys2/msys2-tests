#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MSYS" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

srcdir="$(cd "$(dirname "$0")" && pwd)"
rm -Rf _build && mkdir _build && cd _build

# https://github.com/msys2/MINGW-packages/issues/23577
if "${CC:-cc}" --version | grep -q 'clang'; then
    clang "$srcdir/main.c" -o main.exe
    llvm-dlltool -d "$srcdir/main.def" -l main.lib -D does_not_exist.exe
    clang -Wl,-delayload=does_not_exist.exe -shared "$srcdir/lib.c" main.lib -o lib.dll
else
    gcc "$srcdir/main.c" -o main.exe
    dlltool --input-def "$srcdir/main.def" --output-delaylib main.lib --dllname does_not_exist.exe
    gcc -shared "$srcdir/lib.c" main.lib -o lib.dll
fi

./main.exe
