#!/bin/bash

set -e

python --version

(cd setuptools-cext && ./test.sh)
(cd setuptools-cython && ./test.sh)

if [[ "$MSYSTEM" == "MSYS" ]]; then
    # Make sure python does not give away that we are not cygwin
    platform="$(python -c "import sys; print(sys.platform)")"
    [[ "$platform" == "cygwin" ]] || (echo "wrong platform: $platform"; false)
    # TODO: sysconfig.get_platform() depends on uname
fi
