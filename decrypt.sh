#!/bin/bash
set -e

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <keyfile> <archive>"
    exit 1
fi

KEYFILE="$1"
ARCHIVE="$2"

# Entpacken des Archives
tar xf "${ARCHIVE}"

# Entschluesseln des AES Keys
openssl rsautl -decrypt -inkey "${KEYFILE}" -in key.enc -out key.bin

# Entschluesseln des Backups
openssl enc -d -aes256 -md sha256 -in "secrets.enc" -out "secrets.json" -pass "file:key.bin"
