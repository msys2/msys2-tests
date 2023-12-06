#!/bin/bash

set -e

TEMPDIR=$(mktemp -d)

pacman-key --gpgdir "$TEMPDIR" --init
pacman-key --gpgdir "$TEMPDIR" --populate
pacman-key --gpgdir "$TEMPDIR" --refresh-keys

function check_packager_key_full_trust() {
    output=$(pacman-key --list-keys "$1" --gpgdir "$TEMPDIR" | grep '^uid' | awk '{print $3}')
    if [[ "$output" != "full" ]]; then
        echo "Error: Key $1 does not have full trust"
        exit 1
    fi
}

check_packager_key_full_trust "AD351C50AE085775EB59333B5F92EFC1A47D45A1"
check_packager_key_full_trust "87771331B3F1FF5263856A6D974C8BE49078F532"
check_packager_key_full_trust "5F944B027F7FE2091985AA2EFA11531AA0AA7F57"

rm -rf "$TEMPDIR"
