#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

cd meson
rm -Rf _build
meson setup _build --werror
meson compile -C _build
meson test -C _build
cd ..

./tools/test.sh
