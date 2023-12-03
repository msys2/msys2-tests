#!/bin/bash

set -e

export GNUPGHOME=$(mktemp -d)
TEMPDIR=$(mktemp -d)
cd "$TEMPDIR"

# Generate a key pair
gpg --batch --passphrase '' --quick-generate-key "Test User <test@example.com>"

# List keys
gpg --list-keys

# Encrypt
echo "This is a test file." > test.txt
gpg --batch --yes --passphrase '' -r "Test User" -o test.txt.gpg --encrypt test.txt
gpg --batch --yes --passphrase '' -o decrypted.txt --decrypt test.txt.gpg

# Sign
gpg --batch --yes --passphrase '' -o test.txt.sig --detach-sign test.txt
gpg --verify test.txt.sig test.txt

# Cleanup
gpgconf --kill all
rm -rf "$GNUPGHOME"
rm -rf "$TEMPDIR"
