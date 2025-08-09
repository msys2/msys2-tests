#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MSYS" ]]; then
    cd msys
    makepkg --version
    makepkg -Csfr --noconfirm
else
    cd mingw
    makepkg-mingw --version
    makepkg-mingw -Csfr --noconfirm
fi
