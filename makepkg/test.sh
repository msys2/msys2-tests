#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MSYS" ]]; then
    cd msys
    makepkg -Csfr --noconfirm
else
    cd mingw
    makepkg-mingw -Csfr --noconfirm
fi
