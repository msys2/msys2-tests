#!/bin/bash

set -e

cd meson
meson setup _build --werror
meson compile -C _build
meson test -C _build
cd ..

if [[ "$MSYSTEM" == "MSYS" ]]; then
    cd meson
    meson setup -Dcross=true --cross-file i686-w64-mingw32.txt _build_cross_32 --werror
    meson compile -C _build
    meson test -C _build
    cd ..

    cd meson
    meson setup -Dcross=true --cross-file x86_64-w64-mingw32.txt _build_cross_64 --werror
    meson compile -C _build
    meson test -C _build
    cd ..
fi

cd custom
./test.sh
