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

`needs`: `build` needs `gate`; `attest` needs `build`; `publish` needs `gate`,
`build` and `attest`; `github-release` needs `publish`; `verify` needs
`github-release`. Jobs 3 to 6 run only when `needs.gate.outputs.publish == 'true'`.

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
- Obtains a short-lived token from the pinned `rust-lang/crates-io-auth-action`.
- Runs `cargo publish --locked` for each release crate in dependency order,
  using the same toolchain as `build`. It skips a version crates.io already has,
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

rust-mirror and rust-mirror-gui keep their separate `release-binaries.yml` for
now. Their `github-release` job creates the release, and the binary workflow
attaches its archives, its own `SHA256SUMS` and its `<repo>-<version>.intoto.jsonl`
bundle to it. To avoid a name clash, the crate checksum file in these two
repositories is `SHA256SUMS-crates`.

**Phase 2 (planned, not approved for implementation yet):** fold the binary
builds into this pipeline as part of `build` and `attest`, with one
`SHA256SUMS`, keeping every existing qualification gate unchanged. This is
deliberately separate from adopting the standard, because those builds carry
the qualified GNU userland checks.

## Rollout tracker

| Repository | Before | Adoption |
|---|---|---|
| cargo-libc | `publish` only | Pilot: planned |
| glibc-provider | `publish` only | Planned after the pilot |
| glibc-abilists | `dry-run`, `publish` | Planned after the pilot |
| linux-abi-tools | `dry-run`, `publish` (five crates) | Planned after the pilot |
| rust-mirror | `qualify`, `publish` | Planned after its 0.6.0 release closes |
| rust-mirror-gui | `check`, `publish`, `verify` | Planned after its 0.5.2 release closes |
| rust-musl-libc-compat-test, cargo-binpack, .github | publish nothing | Not applicable until a crate ships |

Each adoption is one pull request whose dry run passes before merge. The first
real use is the repository's next authorized release; no published version is
re-tagged or re-released. Update this table as each adoption merges.
