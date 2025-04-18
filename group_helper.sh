#!/bin/bash

if [[ "${BASH_SOURCE}" = "$0" ]]; then
  echo "This script is intended to be sourced, not run"
  exit 1
fi

trap 'echo "::endgroup::"' EXIT
echo "::group::$1"
