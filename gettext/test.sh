#!/bin/bash

set -e

cd meson
rm -Rf _build
meson setup _build --werror
meson compile -C _build
meson test -C _build
