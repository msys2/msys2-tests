#!/bin/bash

set -e

python --version

(cd setuptools-cext && ./test.sh)
(cd setuptools-cython && ./test.sh)
(cd setuptools-rust && ./test.sh)

if [[ "$MSYSTEM" == "MSYS" ]]; then
    # Make sure python does not give away that we are not cygwin
    sys_platform="$(python -c "import sys; print(sys.platform)")"
    [[ "$sys_platform" == "cygwin" ]] || (echo "wrong platform: $sys_platform"; false)
    sysconfig_platform="$(python -c "import sysconfig; print(sysconfig.get_platform())")"
    [[ "$sysconfig_platform" == "cygwin-$MSYSTEM_CARCH" ]] || (echo "wrong platform: $sysconfig_platform"; false)
fi
