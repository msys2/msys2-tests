#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ "$MSYSTEM" != "MSYS" ]]
then
    generators=('Ninja' 'MSYS Makefiles' 'MinGW Makefiles')
else
    generators=('Ninja' 'Unix Makefiles')
fi

for gen in "${generators[@]}"
do
    rm -Rf _build
    mkdir _build
    pushd _build
        cmake -G"$gen" ..
        cmake --build .
        ctest .
    popd
done
