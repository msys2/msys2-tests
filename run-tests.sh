#!/bin/bash

set -e -o pipefail

test_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

for suite in toolchain rust python cmake autotools golang fortran ruby perl nodejs runtime ada tools makepkg libtool gettext keyring; do
    (
        trap 'echo "::endgroup::"' EXIT
        echo "::group::test: $suite"
        make -C "$test_path" -j "$suite"
    )
done
