#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

WANT_AUTOCONF='latest' WANT_AUTOMAKE='latest' autoreconf -vfi
rm -Rf _build && mkdir _build && cd _build
../configure
make
make check
make distclean
cd ..

# Also test with older autotools, which is still quite common
WANT_AUTOCONF='2.69' WANT_AUTOMAKE='1.15' autoreconf -vfi
rm -Rf _build && mkdir _build && cd _build
../configure
make
make check
make distclean
