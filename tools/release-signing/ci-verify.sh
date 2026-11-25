#!/usr/bin/env bash
# Verify a detached signature using ONLY a pinned public key, and require that the
# signing key belongs to the pinned primary fingerprint.
#
#   ci-verify.sh FILE SIGNATURE PUBLIC_KEY PRIMARY_FINGERPRINT
#
# Exits non-zero unless there is exactly one good signature (GOODSIG and VALIDSIG)
# by a key whose primary fingerprint equals PRIMARY_FINGERPRINT, with no revoked,
# expired, bad or unknown-key status, and the key file itself has that fingerprint.
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
# gpg still reports VALIDSIG for a signature made by a revoked or expired key
# (next to REVKEYSIG or EXPKEYSIG), so check every status line, not only VALIDSIG.
# A revoked key is always refused: revocation means the key may be compromised
# (rotate WITHOUT revoking unless it was exposed). An expired subkey is accepted
# only for signatures made before it expired, so older releases stay verifiable.
BAD=$(printf '%s\n' "$STATUS" | awk '$1=="[GNUPG:]" && $2 ~ /^(REVKEYSIG|KEYREVOKED|EXPSIG|BADSIG|ERRSIG|NO_PUBKEY)$/ {print $2}' | sort -u | tr '\n' ' ')
[ -z "$BAD" ] || { echo "Signature on $FILE refused: $BAD"; exit 1; }
if printf '%s\n' "$STATUS" | awk '$1=="[GNUPG:]" && $2=="EXPKEYSIG"' | grep -q .; then
  SIGKEY=$(printf '%s\n' "$STATUS" | awk '$1=="[GNUPG:]" && $2=="VALIDSIG"{print $3; exit}')
  SIGTIME=$(printf '%s\n' "$STATUS" | awk '$1=="[GNUPG:]" && $2=="VALIDSIG"{print $5; exit}')
  KEYEXP=$(gpg --batch --with-colons --list-keys | awk -F: -v k="$SIGKEY" '($1=="pub"||$1=="sub"){e=$7} $1=="fpr" && $10==k {print e; exit}')
  if [ -z "$SIGKEY" ] || [ -z "$SIGTIME" ] || [ -z "$KEYEXP" ] || [ "$SIGTIME" -ge "$KEYEXP" ]; then
    echo "Signature on $FILE refused: made with an expired key (signed $SIGTIME, key expired ${KEYEXP:-unknown})"; exit 1
  fi
  echo "Note: the signing key has since expired; the signature was made before expiry and is accepted."
fi
GOOD=$( (printf '%s\n' "$STATUS" | awk '$1=="[GNUPG:]" && ($2=="GOODSIG" || $2=="EXPKEYSIG")') | wc -l)
VALIDS=$(printf '%s\n' "$STATUS" | awk '$1=="[GNUPG:]" && $2=="VALIDSIG"' | wc -l)
[ "$GOOD" -eq 1 ] && [ "$VALIDS" -eq 1 ] || { echo "Signature on $FILE refused: expected exactly one good signature (GOODSIG=$GOOD VALIDSIG=$VALIDS)"; exit 1; }
# VALIDSIG <signing-key-fpr> <date> <timestamp> <expire> <ver> <res> <pk-algo> <hash-algo> <class> <primary-fpr>
VALID=$(printf '%s\n' "$STATUS" | awk '$1=="[GNUPG:]" && $2=="VALIDSIG"{print $NF}')
[ "$VALID" = "$PRIMARY" ] || { echo "Signature on $FILE is not a valid signature by the pinned key $PRIMARY"; exit 1; }
echo "Verified $SIG: valid signature by primary key $PRIMARY"
