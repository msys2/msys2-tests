#!/bin/bash

set -e

check_libraries_reproducible() {
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=915055
    rm -Rf _reproducible
    mkdir _reproducible && cd _reproducible
    echo 'int foo(){return 42;}' > foo.c
    SOURCE_DATE_EPOCH=0 "${CC:-cc}" -shared foo.c -o foo.dll -Wl,--out-implib=foo1.dll.a
    mv foo.dll foo1.dll
    sleep 1
    SOURCE_DATE_EPOCH=0 "${CC:-cc}" -shared foo.c -o foo.dll -Wl,--out-implib=foo2.dll.a
    mv foo.dll foo2.dll
    diff foo1.dll foo2.dll
    diff foo1.dll.a foo2.dll.a
    cd ..
    rm -Rf _reproducible
}

if [[ "$MSYSTEM" == "MSYS" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

check_libraries_reproducible
