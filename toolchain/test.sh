#!/bin/bash

set -e

cd meson
meson _build --werror
meson compile -C _build
meson test -C _builds
