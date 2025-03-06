#!/bin/bash

set -ex

srcdir="$(cd "$(dirname "$0")" && pwd)"
rm -Rf _build && mkdir _build && cd _build

# https://github.com/msys2/MINGW-packages/issues/23577
for helper in "" "-ldloadhelper"; do
  if [[ "$MSYSTEM" == "MSYS" && "x$helper" == "x" ]]; then
    echo "skipped on $MSYSTEM"
    continue
  fi

  if "${CC:-cc}" --version | grep -q 'clang'; then
    clang "$srcdir/main.c" -Wl,--output-def,main.def -o main.exe
    llvm-dlltool -d "main.def" -l main.lib -D does_not_exist.exe
    clang -fuse-ld=lld -Wl,-delayload=does_not_exist.exe -shared "$srcdir/lib.c" main.lib -o lib.dll $helper
  else
    gcc "$srcdir/main.c" -Wl,--output-def,main.def -o main.exe
    dlltool --input-def "main.def" --output-delaylib main.lib --dllname does_not_exist.exe
    gcc -shared "$srcdir/lib.c" main.lib -o lib.dll $helper
  fi

  ./main.exe
done
