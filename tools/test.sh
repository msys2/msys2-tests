#!/bin/bash

set -e

if [[ "$MSYSTEM" != "CLANGARM64" ]]; then
    # This fails in case exception handling is broken for example, see
    # https://github.com/msys2/MINGW-packages/pull/16968#issuecomment-1533702758
    "$MSYSTEM_PREFIX/bin/gdb" -ex=bt -ex=q
fi

./git.sh

if [[ "$MSYSTEM" == "MSYS" ]]; then
    ./gnupg.sh
fi

./shells.sh

./openssh.sh
