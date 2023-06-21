#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

TARGET_DIR="$1"

cp -r ./example "$TARGET_DIR"
cd "$TARGET_DIR"
autoreconf -vfi
rm -Rf _build && mkdir _build && cd _build
../configure
make
make check
make distclean
