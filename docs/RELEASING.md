# Release documentation convention

This is the shared release-documentation contract for Rust Commons repositories
that ship versioned software. The organization profile and unreleased
placeholders adopt the instruction without inventing software releases.

The [current release matrix](RELEASE-STATUS.md) coordinates producer publication,
consumer dependency adoption and registry delivery. Update those stages separately
and link authoritative per-project evidence; preserve dated adoption snapshots.

## Reader-facing records

Maintain a root CHANGELOG.md based on Keep a Changelog: an Unreleased section,
then dated entries in descending version order. Record actual user-visible
changes as they are made. Do not present proposals as shipped. Documentation-only
software releases must state when verified code, API and data are unchanged.

Every existing release version has reviewed docs/releases/vX.Y.Z.md notes. Begin
with the version and user outcome, then include these sections:

- Changes: what changed and why it matters; distinguish features, fixes and docs.
- Upgrade: installation or dependency adoption, migration, configuration/cache
  impact and changed prerequisites. A library uses a Cargo dependency, not
  cargo install unless it actually ships a CLI.
- Validation and limits: bounded named evidence and gaps. Distinguish host tests,
  static inspection, simulation and actual target execution.
- Links: immutable source tag/commit, applicable crates.io/docs.rs pages,
  changelog and detailed release evidence.

GitHub Release bodies come from those reviewed files. Titles identify the version
and outcome. Link detailed qualification records rather than pasting CI logs.
The README links changelog, GitHub Releases and maintained release policy.
Preserve installation-first READMEs; detailed usage belongs in maintained guides.

## Existing history

Backfill only existing verified tags, using source diffs, registry dates/archives
and records. State unavailable historical evidence. Distinguish original release
dates from the later documentation publication date. Source-only historical tags
must not be described as published crates.

Old source tags predate these files. Never link a backfilled changelog at a tag
where it did not exist. Use valid absolute links to maintained documentation or
its new documentation commit. Release-body links must be absolute.

Do not move/recreate tags, republish crates, invent checks or rewrite historical
results. Repository Markdown and GitHub Release entries cannot change immutable
registry archives or their docs.rs versions.

## Completion gates

Before routine release-preparation merges:

1. Update changelog and notes for the manifest version.
2. Review user impact, dependency requirements, licensing/provenance and scope
   against source and approved decisions.
3. Run the release-documentation checker and CI workflow; inspect links,
   commands, Markdown rendering and diff.
4. Run product checks appropriate to the actual software changes only.

For a first workflow installation, GitHub requires default-branch registration
before dispatch. Bootstrap therefore uses independent local/syntax review,
normal merge, then an immediate green docs workflow before completing bootstrap
or publishing notes. A registration 404 is not a passing CI result. Subsequent
routine merges use the registered workflow before merge.

After an authorized software publication, verify source tag, official archives
and applicable install gates under the maintained repository release policy.
Publish the reviewed GitHub Release body and verify it live. A crate upload or
source tag alone does not complete a release.

Documentation backfill authorizes notes for already shipped tags, not new
software versions. GitHub Releases supplement crates.io with notes and
source/registry links. No compiled SDKs, standalone binaries or new distribution
artifacts are attached without separate authorization.

## Automated checks

The four published libc/ABI repositories share the same standard-library-only
scripts/check-release-docs.py (Python 3.11+) and small
.github/workflows/release-docs.yml. Missing changelogs, uncovered current
versions, missing notes/sections, invalid dates and relative release-body links
fail the check. Note versions and dated changelog entries must agree.

Before publication:

    python3 scripts/check-release-docs.py --repo rustcommons/REPOSITORY

After backfilling all existing notes:

    python3 scripts/check-release-docs.py --repo rustcommons/REPOSITORY --published

For a published-release event:

    python3 scripts/check-release-docs.py --repo rustcommons/REPOSITORY --published-tag vX.Y.Z

Live checks compare actual Release bodies with reviewed files and verify source
tags; complete verification checks latest-version selection too. Public GitHub
API access or GH_TOKEN/GITHUB_TOKEN is used. Never print credentials.

The workflow covers pushes/PRs, manual dispatch and published/edited Release
events where its definition exists. It checks default-branch docs for Release
events because historical tags predate the backfill. Historical events lacking
the new workflow still need explicit live verification. Missing/skipped runs are
not passes. Structural, link and presentation checks do not prove runtime behavior.

## Adoption and instructions

Every repository keeps the exact Release documentation section in its primary
AGENTS.md. CLAUDE.md stays a shim; no-tool-attribution and technical constraints
remain intact. Repositories without shipped versions record release verification
as Not applicable until the first authorized release.

The 2026-11-02 audit found tags and detailed validation records but no GitHub
Releases or root CHANGELOG.md in cargo-libc, linux-abi-tools, glibc-abilists or
glibc-provider. Reviewed backfill commits and published notes provide adoption
evidence; this central policy alone does not claim cross-repository completion.

## Completed rollout: 2026-11-02

All eight repositories adopted the exact shared release-documentation instructions.
The four published projects now have root changelogs, reviewed versioned notes,
registered documentation CI, and 20 GitHub Releases for their existing tags:

| Repository | Historical notes | Latest documented version | Full live-notes verification |
| --- | --- | --- | --- |
| [linux-abi-tools](https://github.com/rustcommons/linux-abi-tools/releases) | 7 | 0.4.0 | [Passed run 41388248802](https://github.com/rustcommons/linux-abi-tools/actions/runs/41388248802) |
| [glibc-provider](https://github.com/rustcommons/glibc-provider/releases) | 2 | 0.1.1 | [Passed run 41387968372](https://github.com/rustcommons/glibc-provider/actions/runs/41387968372) |
| [glibc-abilists](https://github.com/rustcommons/glibc-abilists/releases) | 3 | 0.1.2 | [Passed run 41387980296](https://github.com/rustcommons/glibc-abilists/actions/runs/41387980296) |
| [cargo-libc](https://github.com/rustcommons/cargo-libc/releases) | 8 | 0.3.0 | [Passed run 41387908379](https://github.com/rustcommons/cargo-libc/actions/runs/41387908379) |

The full checks compare live bodies with committed notes and check tag coverage
and latest selection. Independent review also checked original tag identities and
zero uploaded assets. The four checker/workflow copies are identical; the checker
rejects missing historical coverage and relative reference-style links, including
multiline labels. Bootstrap CI passed before notes were published. Brief workflow
registration/API visibility delays were retried; they were not counted as passes.

This remediation changed documentation and maintenance checks, not software,
versions, dependencies, lockfiles, source tags or registry archives. Unavailable
historical CI evidence remains identified in the individual notes. The musl probe,
profile and two placeholders do not acquire invented release histories. Future
releases still require their own product and live-documentation checks; this
snapshot does not qualify runtime behavior or implement the proposed cargo-libc
0.4.0 unwinder design.
