#!/usr/bin/env bash
# Sign a checksum file in CI and verify the signature before anything else uses it.
#
#   ci-sign.sh FILE PUBLIC_KEY PRIMARY_FINGERPRINT SUBKEY_FINGERPRINT
#
# Environment (set these on this step ONLY, from protected-environment secrets):
#   RELEASE_SIGNING_KEY         armored secret SUBKEY export (no primary secret)
#   RELEASE_SIGNING_PASSPHRASE  its passphrase
# Writes FILE.asc. The passphrase goes to gpg on stdin only: never argv, files or logs.
set -euo pipefail
FILE=$1 PUBKEY=$2 PRIMARY=$3 SUBKEY=$4
: "${RELEASE_SIGNING_KEY:?RELEASE_SIGNING_KEY is not set}"
: "${RELEASE_SIGNING_PASSPHRASE:?RELEASE_SIGNING_PASSPHRASE is not set}"

SIGN_HOME=$(mktemp -d); chmod 700 "$SIGN_HOME"
cleanup() { GNUPGHOME="$SIGN_HOME" gpgconf --kill gpg-agent 2>/dev/null || true; rm -rf "$SIGN_HOME"; }
trap cleanup EXIT

printf '%s' "$RELEASE_SIGNING_KEY" | GNUPGHOME="$SIGN_HOME" gpg --batch --quiet --import
printf '%s' "$RELEASE_SIGNING_PASSPHRASE" | GNUPGHOME="$SIGN_HOME" gpg --batch --yes \
  --pinentry-mode loopback --passphrase-fd 0 --local-user "${SUBKEY}!" \
  --armor --detach-sign --output "$FILE.asc" "$FILE"

# Verify against the committed public key, never against the key we just imported.
"$(dirname "$0")/ci-verify.sh" "$FILE" "$FILE.asc" "$PUBKEY" "$PRIMARY"
echo "Signed $FILE -> $FILE.asc"
