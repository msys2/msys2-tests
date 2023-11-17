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

    if [[ "$MSYSTEM" == "MSYS" ]]
    then
        for target in 'x86_64-w64-mingw32ucrt' 'x86_64-w64-mingw32' 'i686-w64-mingw32'
        do
            rm -Rf "_build_${target}"
            mkdir "_build_${target}"
            pushd "_build_${target}"
                cmake "-DCMAKE_TOOLCHAIN_FILE=${target}.cmake" -G"$gen" ..
                cmake --build .
                PATH="$(echo "/opt/lib/gcc/${target}/"*):$PATH" ctest .
            popd
        done
    fi
done
