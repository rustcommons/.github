# Standard release pipeline: `trusted-publishing.yml`

Every Rust Commons repository that publishes crates uses the same release
pipeline: same file, workflow name, job ids, job display names, order and
permissions. A reader of any repository's Actions tab sees the same six jobs.
The owner approved this standard on 2026-11-21.

crates.io binds Trusted Publishing to the repository, the workflow **file name**
`.github/workflows/trusted-publishing.yml` and the environment `crates-io`.
Those two identities never change. Job ids and names are not part of the
registration, so adopting this standard needs no crates.io change.

## The pipeline

Workflow `name: Trusted publishing`.

| # | Job id | Display name | Runs on | Purpose | Extra permissions |
|---|---|---|---|---|---|
| 1 | `gate` | Release gate | every run | Decide whether this run may publish. | `actions: read` |
| 2 | `build` | Build | every run | Package, test and checksum exactly what will be published. | none |
| 3 | `attest` | Checksums and attestations | tag runs | Sign provenance for the checksummed files. | `id-token: write`, `attestations: write` |
| 4 | `publish` | Publish to crates.io | tag runs, after owner approval | Publish through Trusted Publishing. | `id-token: write` (environment `crates-io`) |
| 5 | `github-release` | GitHub release | tag runs | Create the release from committed notes and attach the files. | `contents: write` |
| 6 | `verify` | Verify publication | tag runs | Prove that what crates.io serves is what was built and signed. | none |

`needs`: `build` needs `gate`; `attest` needs `gate` and `build`; `publish`
needs `gate`, `build` and `attest`; `github-release` needs `gate` and `publish`;
`verify` needs `gate` and `github-release`. Jobs 3 to 6 run only when
`needs.gate.outputs.publish == 'true'`; each lists `gate` directly because a job
can read outputs only from the jobs it names in `needs`.

### 1. Release gate

On a `v*` tag, all of these must hold, or the run fails before anything is built:

- The tag is annotated, and its name is `v` plus the release version.
- The tagged commit is reachable from `main`, and CI succeeded on that commit.
- Every crate whose version equals the release version is in the release set;
  every other workspace crate is already on crates.io at its declared version.
- **`CHANGELOG.md` has a dated `## [X.Y.Z] - YYYY-MM-DD` entry** for the release
  version, and `docs/releases/vX.Y.Z.md` exists. The changelog entry is the
  record the release notes are written from; a release without it is refused.

On pull requests and manual runs the gate reports what it found, sets
`publish=false` and lets the dry run continue. Outputs: `version`, `publish`
and the ordered crate list.

### 2. Build

- `cargo package --locked` for each release crate in dependency order; this also
  builds each crate from its packaged source.
- A CycloneDX SBOM from `cargo-cyclonedx`, installed with `--locked` at a pinned
  version.
- `SHA256SUMS` over the `.crate` files and the SBOM.
- Uploads one artifact, `release-<version>`, holding all of the above.

Repositories with extra release qualification (package audits, candidate
installs) run it here, so a pull request dry run exercises it too.

### 3. Checksums and attestations

Re-checks `SHA256SUMS`, then signs GitHub artifact attestations (Sigstore, SLSA
build provenance) for every `.crate` file and the SBOM. Saves the signed bundle
as `<repo>-<version>.crates.intoto.jsonl` in the release artifact.

### 4. Publish to crates.io

The only job with the `crates-io` environment: the owner's approval click.

- Re-checks the downloaded files against `SHA256SUMS`.
- With **no token present**, runs `cargo package --locked` for each release
  crate and `cmp`s it against the attested `.crate`. Packaging runs dependency
  build scripts and proc macros, so the token must not be in their environment.
- Only then obtains a short-lived token from the pinned
  `rust-lang/crates-io-auth-action`, and runs `cargo publish --locked
  --no-verify` for each release crate in dependency order, with
  `CARGO_REGISTRY_TOKEN` set on that step alone. `build` has already proved
  each package builds. It skips a version crates.io already has,
  so a re-run after a partial failure is safe.

### 5. GitHub release

Creates release `vX.Y.Z` with `--verify-tag` from the committed
`docs/releases/vX.Y.Z.md`, so the published body equals the reviewed file. The
title is that file's first heading. Attaches the `.crate` files, the SBOM,
`SHA256SUMS` and the provenance bundle. On a re-run it uploads only missing
files and never replaces an existing asset.

### 6. Verify publication

- crates.io's checksum for each published crate equals the attested `.crate`
  file's SHA-256.
- `gh attestation verify` succeeds for every attached file against this
  repository and this workflow.
- docs.rs reports a successful build. A queue that is still pending after the
  bounded wait is reported as pending, not as a pass.
- Crates that ship executables pass a clean `cargo install --locked` into an
  empty root and report the release version.

## Common settings

- Triggers: `push: tags: ['v*']` publishes. `pull_request` (filtered to the
  workflow and release scripts) and `workflow_dispatch` are dry runs that run
  jobs 1 and 2 and never publish.
- Top-level `permissions: contents: read`; every extra permission is granted
  only in the job listed above.
- `concurrency: group: trusted-publishing-${{ github.ref }}`, with
  `cancel-in-progress` true only for pull requests. A tag run is never cancelled.
- Runners `ubuntu-24.04`. Actions pinned to full commit SHAs with version
  comments; checkout with `persist-credentials: false`. Tools installed with
  `--locked` at exact versions. No `[skip ci]`.

## Repositories that also ship binaries

rust-mirror and rust-mirror-gui ship prebuilt binaries. The owner approved
phase 2 on 2026-11-21: one pipeline builds, signs and publishes everything,
replacing the separate `release-binaries.yml`.

They use a **binary variant** of the standard, because SLSA Build L3 needs the
build and the signature in the same isolated reusable workflow:

- `build` is `uses: ./.github/workflows/build-binaries.yml`. That reusable
  workflow builds every binary target through the read-only
  `build-binaries-core.yml` with all qualification gates, packages the
  `.crate`, generates the SBOMs and one `SHA256SUMS`, and then, only on a `v*`
  tag push it re-verifies, signs its **own** output in its nested job
  "Checksums and attestations". The caller cannot choose what is signed.
- There is no top-level `attest` job. The caller's `build` job grants
  `id-token: write` and `attestations: write`, which the nested signer alone
  uses; PR and manual dry runs build everything but never sign.
- Building and signing finish **before** the owner's `crates-io` approval, so
  approval timing does not matter.
- `github-release` creates the release as a draft, checks its tag, title, body
  and state against the committed notes, uploads every asset, checks each by
  name, size and digest, then publishes and checks again. A re-run resumes a
  draft and never modifies a published release.
- Assets: the `.crate`, every binary archive, the SBOM, one `SHA256SUMS` and one
  `<repo>-<version>.intoto.jsonl` bundle covering every signed file.
- Verifiers keep accepting earlier releases' layouts exactly, and require the new
  layout only for later versions.

Rollout: rust-mirror pilot (rust-mirror#76), then rust-mirror-gui.

## Lessons from the rollout

- **Gate CI lookup:** GitHub's `status=success` filter on workflow runs can
  return no runs for a commit whose CI succeeded. Read every run for the
  commit (`?head_sha=SHA&per_page=100`) and require one with
  `conclusion == 'success'` (cargo-libc#44).
- **Fuzz workspace locks:** a version bump must also update `fuzz/Cargo.lock`
  (and any exact `=X.Y.Z` pin in `fuzz/Cargo.toml`), or the locked fuzz build fails.
- **Binary repositories:** signing must stay in the reusable workflow that
  built the files; a signer that signs a caller-supplied artifact no longer
  proves the qualified build made it (rust-mirror#76 review). A killed
  `gh release create` leaves a draft that the tags API cannot see, so create
  drafts deliberately and resume them through the releases list.
- **Smoke tests:** don't pipe a program's output into `head` under `pipefail`;
  write it to a file first.

## Rollout tracker

| Repository | Before | Adoption |
|---|---|---|
| cargo-libc | `publish` only | Adopted: cargo-libc#43 (pilot), gate fix #44 |
| glibc-provider | `publish` only | Adopted: glibc-provider#18 |
| glibc-abilists | `dry-run`, `publish` | Adopted: glibc-abilists#16 |
| linux-abi-tools | `dry-run`, `publish` (five crates) | Adopted: linux-abi-tools#28 |
| rust-mirror | `qualify`, `publish` | Adopted: rust-mirror#75 |
| rust-mirror-gui | `check`, `publish`, `verify` | Adopted: rust-mirror-gui#32 |
| rust-musl-libc-compat-test, cargo-binpack, .github | publish nothing | Not applicable until a crate ships |

Each adoption is one pull request whose dry run passes before merge. The first
real use is the repository's next authorized release; no published version is
re-tagged or re-released. Update this table as each adoption merges.
