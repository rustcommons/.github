#!/usr/bin/env bash
# Verify a detached signature using ONLY a pinned public key, and require that the
# signing key belongs to the pinned primary fingerprint.
#
#   ci-verify.sh FILE SIGNATURE PUBLIC_KEY PRIMARY_FINGERPRINT
#
# Exits non-zero unless gpg reports VALIDSIG for a key whose primary fingerprint
# equals PRIMARY_FINGERPRINT, and the committed key file itself has that fingerprint.
set -euo pipefail
FILE=$1 SIG=$2 PUBKEY=$3 PRIMARY=$4
PRIMARY=$(printf '%s' "$PRIMARY" | tr -d ' ' | tr 'a-f' 'A-F')

VERIFY_HOME=$(mktemp -d); chmod 700 "$VERIFY_HOME"
cleanup() { GNUPGHOME="$VERIFY_HOME" gpgconf --kill gpg-agent 2>/dev/null || true; rm -rf "$VERIFY_HOME"; }
trap cleanup EXIT
export GNUPGHOME="$VERIFY_HOME"

gpg --batch --quiet --import "$PUBKEY"
KEYFPR=$(gpg --batch --with-colons --list-keys | awk -F: '/^pub:/{p=1} p&&/^fpr:/{print $10; exit}')
[ "$KEYFPR" = "$PRIMARY" ] || { echo "Public key file fingerprint $KEYFPR does not match the pinned $PRIMARY"; exit 1; }

STATUS=$(gpg --batch --status-fd 1 --verify "$SIG" "$FILE" 2>/dev/null || true)
# VALIDSIG <signing-key-fpr> <date> <timestamp> <expire> <ver> <res> <pk-algo> <hash-algo> <class> <primary-fpr>
VALID=$(printf '%s\n' "$STATUS" | awk '$2=="VALIDSIG"{print $NF; exit}')
[ "$VALID" = "$PRIMARY" ] || { echo "Signature on $FILE is not a valid signature by the pinned key $PRIMARY"; exit 1; }
echo "Verified $SIG: valid signature by primary key $PRIMARY"
