#!/bin/bash

set -e -o pipefail

test_path=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

for suite in toolchain rust python cmake autotools golang fortran ruby perl nodejs runtime ada tools makepkg libtool gettext keyring; do
    # CMake hangs in Docker: https://cygwin.com/pipermail/cygwin-patches/2026q4/015440.html
    if [[ "$suite" == cmake && "${MSYS2_TESTS_IN_DOCKER:-}" == 1 ]]; then
        continue
    fi
    (
        trap 'echo "::endgroup::"' EXIT
        echo "::group::test: $suite"
        make -C "$test_path" -j "$suite"
    )
done
