#!/bin/bash

set -e

cd meson
meson setup _build --werror
meson compile -C _build
meson test -C _build
cd ..

if [[ "$MSYSTEM" == "MSYS" ]]; then
    cd meson
    meson setup --cross-file i686-w64-mingw32.txt _build_cross_32 --werror
    meson compile -C _build_cross_32
    meson test -C _build_cross_32
    cd ..

    cd meson
    meson setup --cross-file x86_64-w64-mingw32.txt _build_cross_64 --werror
    meson compile -C _build_cross_64
    meson test -C _build_cross_64
    cd ..
fi

cd custom
./test.sh
