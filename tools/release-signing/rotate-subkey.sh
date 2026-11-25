#!/usr/bin/env bash
# Add a new signing subkey from the OFFLINE backup (before the old one expires, or
# after an exposure), guide revoking the old subkey, and update GitHub secrets.
# The primary fingerprint does not change, so verifiers keep working.
#
#   rotate-subkey.sh --backup OFFLINE-BACKUP-secret-key.asc --owner example-org \
#       --repos "repo-a repo-b" [--env crates-io] [--revoke-old] [--out DIR] [--no-github]
#
# Afterwards, republish the printed public key file everywhere the old one is
# committed (each repository's pinned copy), and keep the NEW offline backup.
set -euo pipefail

BACKUP="" OWNER="" REPOS="" ENVIRONMENT="crates-io" OUT="" GITHUB=1 REVOKE=0
ALGO="rsa4096" SUBKEY_EXPIRY="2y"
KEY_SECRET="RELEASE_SIGNING_KEY" PASS_SECRET="RELEASE_SIGNING_PASSPHRASE"
usage() { sed -n '2,10p' "$0"; exit 1; }
while [ $# -gt 0 ]; do
  case "$1" in
    --backup) BACKUP="$2"; shift 2 ;;
    --owner) OWNER="$2"; shift 2 ;;
    --repos) REPOS="$2"; shift 2 ;;
    --env) ENVIRONMENT="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --revoke-old) REVOKE=1; shift ;;
    --subkey-expiry) SUBKEY_EXPIRY="$2"; shift 2 ;;
    --no-github) GITHUB=0; shift ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done
[ -f "$BACKUP" ] || { echo "--backup FILE is required (the offline secret-key backup)."; usage; }
if [ "$GITHUB" = 1 ]; then
  [ -n "$OWNER" ] && [ -n "$REPOS" ] || { echo "--owner and --repos are required unless --no-github."; usage; }
  gh auth status >/dev/null 2>&1 || { echo "Run 'gh auth login' first. Nothing was changed."; exit 1; }
fi
OUT="${OUT:-$PWD/signing-key-rotation-out}"
WORK=$(mktemp -d "$HOME/.signing-rotate-XXXXXX"); mkdir -p "$WORK/private-keys-v1.d" "$OUT"; chmod 700 "$WORK"
export GNUPGHOME="$WORK"
CI_KEY=""
cleanup() { [ -n "$CI_KEY" ] && rm -f "$CI_KEY"; gpgconf --kill gpg-agent 2>/dev/null || true; rm -rf "$WORK"; }
trap cleanup EXIT
GPG=(gpg --pinentry-mode loopback)
[ "${SIGNING_KIT_TEST:-0}" = 1 ] && GPG=(gpg --batch --pinentry-mode loopback --passphrase "${SIGNING_KIT_TEST_PASSPHRASE:-test}")

"${GPG[@]}" --quiet --import "$BACKUP"
FPR=$(gpg --list-secret-keys --with-colons | awk -F: '/^sec:/{s=1} s&&/^fpr:/{print $10; exit}')
OLD=$(gpg --list-keys --with-colons "$FPR" | awk -F: '$1=="sub"{s=($2!="r" && $2!="e" && $12 ~ /s/)} $1=="fpr" && s{f=$10; s=0} END{print f}')
echo "Primary: $FPR   current signing subkey: ${OLD:-none}"

"${GPG[@]}" --quick-add-key "$FPR" "$ALGO" sign "$SUBKEY_EXPIRY"
NEW=$(gpg --list-keys --with-colons "$FPR" | awk -F: '$1=="sub"{s=1} $1=="fpr" && s{f=$10; s=0} END{print f}')
echo "New signing subkey: $NEW"
if [ "$REVOKE" = 1 ] && [ -n "$OLD" ]; then
  echo
  echo "Revoke the old subkey $OLD now (do this if it was exposed):"
  echo "  GNUPGHOME=\"$WORK\" gpg --edit-key $FPR"
  echo "    gpg> list            (find the line whose fingerprint is $OLD)"
  echo "    gpg> key N           (N = that subkey's position, counting from 1)"
  echo "    gpg> revkey          (reason 1 = key compromised, or 3 = no longer used)"
  echo "    gpg> save"
  read -rp "Press Enter after revoking (or Ctrl+C to stop without exporting)..." _
fi

gpg --armor --export "$FPR" > "$OUT/release-signing-key.asc"
"${GPG[@]}" --armor --export-secret-keys "$FPR" > "$OUT/OFFLINE-BACKUP-secret-key.asc"

if [ "$GITHUB" = 1 ]; then
  CI_KEY=$(mktemp)
  "${GPG[@]}" --armor --export-secret-subkeys "${NEW}!" > "$CI_KEY"
  read -rsp "Key passphrase (sent only to GitHub): " PASS; echo
  for r in $REPOS; do
    gh secret set "$KEY_SECRET" --env "$ENVIRONMENT" -R "$OWNER/$r" < "$CI_KEY"
    printf '%s' "$PASS" | gh secret set "$PASS_SECRET" --env "$ENVIRONMENT" -R "$OWNER/$r"
    echo "secrets updated: $OWNER/$r ($ENVIRONMENT)"
  done
  unset PASS
fi
echo
echo "Done. Primary fingerprint unchanged: $FPR"
echo "New signing subkey: $NEW   (update the SUBKEY fingerprint used by ci-sign.sh)"
echo "1. Republish $OUT/release-signing-key.asc (every pinned copy)."
echo "2. Move $OUT/OFFLINE-BACKUP-secret-key.asc to offline storage, replacing the old backup; delete it here."
