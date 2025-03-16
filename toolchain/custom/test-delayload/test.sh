#!/bin/bash

set -ex

if [[ "$MSYSTEM" == "MSYS" ]]; then
  echo "skipped on $MSYSTEM"
  exit 0;
fi

srcdir="$(cd "$(dirname "$0")" && pwd)"
rm -Rf _build && mkdir _build && cd _build

for helper in "" "-ldloadhelper"; do
  if "${CC:-cc}" --version | grep -q 'clang'; then
    # lld does not need a special delay import library
    clang -fuse-ld=lld -Wl,-delayload=WS2_32.dll "$srcdir/main.c" -o main.exe -lws2_32 $helper
  else
    if [[ "$MSYSTEM_CARCH" == i?86 ]]; then
      cat "$srcdir/ws2_32.def.in" > ws2_32.def
    else
      # sed lifted from mingw-w64
      sed -E 's/^([^ ]+)@[0-9]+( |$)/\1\2/' "$srcdir/ws2_32.def.in" > ws2_32.def
    fi
    dlltool --input-def "ws2_32.def" --output-delaylib ws2_32.lib
    gcc "$srcdir/main.c" -o main.exe ws2_32.lib $helper
  fi

  ./main.exe
done
