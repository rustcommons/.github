# Release signing kit (OpenPGP)

A small, reusable kit for signing release checksum files with OpenPGP from
GitHub Actions, without a long-lived key ever living on a build machine or in a
chat. Rust Commons uses it for `SHA256SUMS.asc`. It works for any GitHub project.

| File | Who runs it | What it does |
| --- | --- | --- |
| [make-signing-key.sh](make-signing-key.sh) | You, once, in your own terminal | Creates the key, an offline backup and a revocation certificate; puts **only the signing subkey** into GitHub environment secrets |
| [ci-sign.sh](ci-sign.sh) | The release workflow | Signs a checksum file, then verifies the signature against the pinned key |
| [ci-verify.sh](ci-verify.sh) | The release workflow and anyone | Verifies a signature using only a pinned public key and fingerprint |
| [rotate-subkey.sh](rotate-subkey.sh) | You, before the subkey expires or after an exposure | Adds a new signing subkey from the offline backup; the fingerprint stays the same |

## How the key is built

- **Primary key** (RSA-4096, certify only, 5 years): the long-term identity.
  Its fingerprint is what you publish and pin. It stays **offline** with you.
- **Signing subkey** (RSA-4096, sign only, 2 years): the only secret CI gets.
  If it is ever exposed, revoke it and add a new one; the published fingerprint
  doesn't change, so nobody has to re-trust anything.
- **Revocation certificate:** kept offline, for the day the primary key itself
  must be withdrawn.

RSA-4096 is the default because it verifies with every gpg, including the gpg
2.0 on CentOS 7 / RHEL 7. Pass `--algo ed25519` only if every verifier has gpg 2.1+.

## 1. Before you start

- A GitHub **environment** in each repository (for example `crates-io` or
  `release`), restricted to release tags and with you as a **required reviewer**.
  The secrets live there, so only jobs you approve can read them.
- `gpg` and the GitHub CLI (`gh auth login`) in the shell you'll use.
- **WSL users:** run the script inside WSL, but don't point the keyring at a
  Windows drive. The script already keeps it in your Linux home. On `/mnt/c` or
  `/mnt/d`, `gpg-agent` can't create its socket, and you get
  `agent_genkey failed: No such file or directory`.

## 2. Create the key

Run it yourself, never through an assistant or a shared session, so the
passphrase is only ever typed by you:

```sh
bash make-signing-key.sh --name "Example Release Signing" \
  --owner example-org --repos "repo-a repo-b" --env release
```

It asks you to choose a passphrase (store it in your password manager), then
once more to send it to GitHub. It checks your `gh` login and each environment
**before** creating anything, and refuses to touch a keyring that already holds
a key. Use `--no-github` to create the key without setting secrets.

Then, as it tells you:

1. Move `OFFLINE-BACKUP-secret-key.asc` and `OFFLINE-BACKUP-revocation-cert.rev`
   to offline storage (USB drive or password manager) and delete them from disk.
2. Delete the working keyring (the exact command is printed).
3. Note the **primary fingerprint** and keep `release-signing-key.asc` (public).

## 3. Publish the public key

- Commit `release-signing-key.asc` to a public place (for Rust Commons:
  `.github/docs/RELEASE-SIGNING-KEY.asc`) and print the fingerprint in
  `SECURITY.md` with verification steps.
- In each repository, commit a copy (for example `.github/release-signing-key.asc`)
  and pin the primary fingerprint in the release scripts. Add a test that fails if
  the copy's fingerprint differs from the pin.

## 4. Sign in the release workflow

In the job that holds the protected environment, before anything irreversible:

```yaml
- name: Sign SHA256SUMS
  env:
    RELEASE_SIGNING_KEY: ${{ secrets.RELEASE_SIGNING_KEY }}
    RELEASE_SIGNING_PASSPHRASE: ${{ secrets.RELEASE_SIGNING_PASSPHRASE }}
  run: >-
    tools/release-signing/ci-sign.sh dist/SHA256SUMS
    .github/release-signing-key.asc PRIMARY_FINGERPRINT SUBKEY_FINGERPRINT
```

- Set the two secrets on **this step only**. `ci-sign.sh` passes the passphrase
  to gpg on stdin; it never appears on a command line, in a file or in a log.
- Signing happens in a throwaway GnuPG home that is deleted afterwards, and the
  signature is verified against the **committed** public key before the step
  succeeds.
- Run no third-party code in the job that can read these secrets.
- Sign the checksum file, not each artifact: it lists every file's hash, so one
  signature covers the whole release.
- Pull requests can't read environment secrets. Test the signing path with a
  throwaway key generated inside the test, never the real one.

## 5. Verify

In CI (after publishing) and for users:

```sh
tools/release-signing/ci-verify.sh SHA256SUMS SHA256SUMS.asc release-signing-key.asc PRIMARY_FINGERPRINT
sha256sum --check SHA256SUMS
```

Or with plain gpg:

```sh
gpg --import release-signing-key.asc
gpg --fingerprint PRIMARY_FINGERPRINT    # compare with the published fingerprint
gpg --verify SHA256SUMS.asc SHA256SUMS
sha256sum --check SHA256SUMS
```

`ci-verify.sh` accepts a signature only if gpg reports `VALIDSIG` for a key whose
**primary** fingerprint equals the pin, and only if the key file itself has that
fingerprint. A signature by any other key, or a changed file, is refused.

## 6. Rotate the signing subkey

Do this some weeks before the subkey expires, or immediately if it may have been
exposed:

```sh
bash rotate-subkey.sh --backup /path/to/OFFLINE-BACKUP-secret-key.asc \
  --owner example-org --repos "repo-a repo-b" --env release [--revoke-old]
```

Then republish the new public key file everywhere a copy is pinned, update the
subkey fingerprint passed to `ci-sign.sh`, and replace your offline backup with
the new one. The primary fingerprint stays the same, so verifiers keep working.

If the **primary** key is ever compromised, publish the revocation certificate
(`gpg --import OFFLINE-BACKUP-revocation-cert.rev`, then re-export and republish
the public key), and create a new key with a new fingerprint.

## OpenPGP and Sigstore

This complements, not replaces, Sigstore / GitHub artifact attestations. An
attestation proves *which workflow at which commit* built the bytes, without any
long-lived key. An `.asc` proves *the holder of this key* approved them, and
verifies with nothing but `gpg`, which some regulated and disconnected
environments require. Rust Commons ships both.

## Testing the kit

The scripts support a non-interactive test mode for throwaway keys only:
`SIGNING_KIT_TEST=1` (passphrase `test`, or `SIGNING_KIT_TEST_PASSPHRASE`). Run
it with `HOME` pointed at a temporary folder and `--no-github`. Never use test
mode for a real key.
