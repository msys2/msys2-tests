#!/bin/bash

set -e

test_dev_fd_symlinks() {
    # We used to need to create /dev/fd symlinks for this to work
    # but that's no longer the case since
    # https://github.com/cygwin/cygwin/commit/4ec08891a005c040da5bf7c38ae4
    # Test it here just to be sure
    diff -u <(seq 0 10) <(seq 0 10)
}

test_dev_fd_symlinks
