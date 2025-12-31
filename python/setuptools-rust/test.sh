#!/bin/bash

set -e

if [[ "$MSYSTEM" == "MINGW32" ]]; then
    echo "skipped on $MSYSTEM"
    exit 0;
fi

# should be fixed in the next pyo3 version (0.28)
link_arg=$(python -c "import sysconfig; print(sysconfig.get_config_var('LIBPYTHON'))")
export RUSTFLAGS="-C link-arg=$link_arg"

./setup.py build_rust --inplace
python -m setuptools_rust_test
