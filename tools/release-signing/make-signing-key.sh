#!/usr/bin/env bash
# Create an OpenPGP release-signing key and store its signing subkey in GitHub
# environment secrets. Run it yourself in a terminal (WSL, Linux, macOS or Git
# Bash). Private material never leaves this machine except into GitHub secrets,
# and the script prints only public data.
#
#   make-signing-key.sh --name "Example Release Signing" --owner example-org \
#       --repos "repo-a repo-b" [--env crates-io] [--out DIR] [--no-github]
#
# See README.md in this folder before using it.
set -euo pipefail

NAME="" OWNER="" REPOS="" ENVIRONMENT="crates-io" OUT="" GITHUB=1
ALGO="rsa4096" PRIMARY_EXPIRY="5y" SUBKEY_EXPIRY="2y"
KEY_SECRET="RELEASE_SIGNING_KEY" PASS_SECRET="RELEASE_SIGNING_PASSPHRASE"

usage() { sed -n '2,12p' "$0"; exit 1; }
while [ $# -gt 0 ]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    --owner) OWNER="$2"; shift 2 ;;
    --repos) REPOS="$2"; shift 2 ;;
    --env) ENVIRONMENT="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --algo) ALGO="$2"; shift 2 ;;
    --primary-expiry) PRIMARY_EXPIRY="$2"; shift 2 ;;
    --subkey-expiry) SUBKEY_EXPIRY="$2"; shift 2 ;;
    --no-github) GITHUB=0; shift ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done
[ -n "$NAME" ] || { echo "--name is required."; usage; }
[ "$GITHUB" = 0 ] || { [ -n "$OWNER" ] && [ -n "$REPOS" ]; } || { echo "--owner and --repos are required unless --no-github."; usage; }

# The keyring must be on a native Linux/macOS filesystem: under WSL, gpg-agent
# cannot create its socket on a Windows drive (/mnt/c, /mnt/d), which fails with
# "agent_genkey failed: No such file or directory".
SLUG=$(printf '%s' "$NAME" | tr 'A-Z ' 'a-z-' | tr -cd 'a-z0-9-')
WORK="$HOME/.signing-keyhome-$SLUG"
OUT="${OUT:-$PWD/signing-key-out-$SLUG}"

# Check GitHub access before creating anything, so a missing login can't leave a half-made key.
if [ "$GITHUB" = 1 ]; then
  command -v gh >/dev/null || { echo "Install the GitHub CLI (gh) in this shell first. Nothing was changed."; exit 1; }
  gh auth status >/dev/null 2>&1 || { echo "Run 'gh auth login' in this shell first. Nothing was changed."; exit 1; }
  for r in $REPOS; do
    gh api "repos/$OWNER/$r/environments/$ENVIRONMENT" >/dev/null 2>&1 \
      || { echo "Cannot reach environment '$ENVIRONMENT' in $OWNER/$r (create it first, with required reviewers). Nothing was changed."; exit 1; }
  done
fi

export GNUPGHOME="$WORK"
if [ -e "$WORK" ]; then
  if [ -n "$(gpg --list-secret-keys --with-colons 2>/dev/null | grep '^sec' || true)" ] || [ -e "$OUT/OFFLINE-BACKUP-secret-key.asc" ]; then
    echo "Refusing: a secret key already exists in $WORK (or its backup in $OUT). Nothing was changed."; exit 1
  fi
  echo "Cleaning up an incomplete earlier attempt in $WORK (no secret key in it)."
  gpgconf --kill gpg-agent 2>/dev/null || true
  rm -rf "$WORK"
fi
mkdir -p "$WORK/private-keys-v1.d" "$OUT"; chmod 700 "$WORK" "$WORK/private-keys-v1.d"
gpgconf --kill gpg-agent 2>/dev/null || true
CI_KEY=""
cleanup() { [ -n "$CI_KEY" ] && rm -f "$CI_KEY"; gpgconf --kill gpg-agent 2>/dev/null || true; }
trap cleanup EXIT

# --batch with an empty passphrase is used only by the self-test (SIGNING_KIT_TEST=1).
GPG=(gpg --pinentry-mode loopback)
[ "${SIGNING_KIT_TEST:-0}" = 1 ] && GPG=(gpg --batch --pinentry-mode loopback --passphrase "${SIGNING_KIT_TEST_PASSPHRASE:-test}")

echo "== 1/6 Primary key: certify only, $ALGO, expires in $PRIMARY_EXPIRY."
echo "   Choose a strong passphrase when asked, and keep it in your password manager."
"${GPG[@]}" --quick-gen-key "$NAME" "$ALGO" cert "$PRIMARY_EXPIRY"
FPR=$(gpg --list-keys --with-colons "$NAME" | awk -F: '/^fpr:/{print $10; exit}')

echo "== 2/6 Signing subkey: $ALGO, expires in $SUBKEY_EXPIRY."
"${GPG[@]}" --quick-add-key "$FPR" "$ALGO" sign "$SUBKEY_EXPIRY"
SUB=$(gpg --list-keys --with-colons "$FPR" | awk -F: '/^sub:/{s=1} s&&/^fpr:/{print $10; exit}')

echo "== 3/6 Public key (safe to publish)."
gpg --armor --export "$FPR" > "$OUT/release-signing-key.asc"

echo "== 4/6 Offline backup (primary + subkey, passphrase-protected) and revocation certificate."
"${GPG[@]}" --armor --export-secret-keys "$FPR" > "$OUT/OFFLINE-BACKUP-secret-key.asc"
cp "$GNUPGHOME/openpgp-revocs.d/$FPR.rev" "$OUT/OFFLINE-BACKUP-revocation-cert.rev"

if [ "$GITHUB" = 1 ]; then
  echo "== 5/6 CI signing subkey only (no primary secret) into '$ENVIRONMENT' environment secrets."
  CI_KEY=$(mktemp)
  "${GPG[@]}" --armor --export-secret-subkeys "${SUB}!" > "$CI_KEY"
  read -rsp "   Re-enter the key passphrase (sent only to GitHub): " PASS; echo
  for r in $REPOS; do
    gh secret set "$KEY_SECRET" --env "$ENVIRONMENT" -R "$OWNER/$r" < "$CI_KEY"
    printf '%s' "$PASS" | gh secret set "$PASS_SECRET" --env "$ENVIRONMENT" -R "$OWNER/$r"
    echo "   secrets set: $OWNER/$r ($ENVIRONMENT)"
  done
  unset PASS
else
  echo "== 5/6 Skipped GitHub secrets (--no-github)."
fi

echo "== 6/6 Done. Public information:"
echo "   Primary fingerprint: $FPR"
echo "   Signing subkey:      $SUB"
echo "   Public key file:     $OUT/release-signing-key.asc"
echo
echo "NOW:"
echo " 1. Move to OFFLINE storage, then delete here:"
echo "      $OUT/OFFLINE-BACKUP-secret-key.asc"
echo "      $OUT/OFFLINE-BACKUP-revocation-cert.rev"
echo " 2. Delete the working keyring:  GNUPGHOME=\"$WORK\" gpgconf --kill gpg-agent; rm -rf \"$WORK\""
echo " 3. Publish the public key file and the primary fingerprint (see README.md)."
