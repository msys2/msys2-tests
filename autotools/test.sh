#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

autoreconf -vfi
mkdir _build && cd _build
../configure
make
make check
