#!/bin/bash

set -e

meson _build --werror
meson compile -C _build
meson test -C _builds
