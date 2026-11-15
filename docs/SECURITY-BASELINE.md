# Rust Commons security baseline

Owner-approved baseline, 2026-11-15. This is the shared maintainer reference for
all Rust Commons repositories. Requirements below describe the required end state;
they do not assert that every repository's workflow rollout or release
qualification is complete. Keep repository-specific implementation and evidence
in each requirements index and PR. The [default security policy](../SECURITY.md)
covers supported versions, private reporting, response targets and disclosure.

## Repository settings

The organization rollout reported the following configured on all nine public
repositories on 2026-11-15: secret scanning and push protection, Dependabot alerts
and security updates, private vulnerability reporting, and CodeQL default setup.
CodeQL coverage depends on detected supported languages; enabled setup alone is
not proof of a completed analysis or runtime security.

- `protect-main`: pull request required, required check `lf-only`, no force pushes
  or branch deletion; an administrator bypass exists. Routine work must still
  use a PR, including administrator work. No direct pushes to `main`.
- `protect-release-tags`: `v*` tags cannot be updated or deleted; no bypass actors.
- Crate repositories: environment `crates-io`, restricted to `v*` tags, with the
  owner as required reviewer. Environment configuration does not by itself
  authorize publishing or configure the crates.io trusted publisher.

This PR changes files, not settings. Read-only API inspection on 2026-11-15
confirmed `.github` private reporting, secret scanning/push protection,
Dependabot security updates, CodeQL default setup for Actions, and both active
rulesets with the conditions above. The other repositories' settings are a
coordinator-reported rollout, not an independent settings audit in this document.

## Required repository changes

1. **Dependency updates.** Maintain `.github/dependabot.yml` for `github-actions`
   and, when there is a Cargo project, `cargo`. Use weekly schedules, group minor
   and patch updates, and set `open-pull-requests-limit: 5` for each ecosystem.
   Cover the actual manifests/workspaces; review major updates separately.
2. **Action identity and permissions.** Pin every third-party action to a full
   commit SHA, including GitHub-maintained actions, with its version tag in a
   trailing comment. Keep workflow-level permissions read-only and grant writes
   only to the job needing them. Disable checkout credential persistence unless
   explicitly needed and justified. Review Dependabot pin updates before merge.
3. **Workflow linting.** Run [zizmor](https://docs.zizmor.sh/integrations/) on PRs.
   Fix findings or justify narrowly scoped suppressions inline; do not turn off
   the gate to bypass findings. Use unprivileged PR execution, not privileged
   execution of untrusted contributions.
4. **Rust dependency policy.** Rust projects run `cargo-deny` in CI with a
   maintained `deny.toml`: RustSec advisories; unmaintained/yanked packages set to
   warn or deny with justification; a license allowlist matching current
   dependencies; multiple versions warned; only crates.io sources, with Git
   dependencies denied unless explicitly justified. Fix findings or record
   bounded exceptions, rationale and remaining risk. A clean run covers the
   selected dependency graph and advisory data at that time.
5. **OpenSSF Scorecard.** Run `ossf/scorecard-action` on pushes to `main` and weekly,
   with `publish_results: true` and SARIF uploaded to code scanning. Scope
   `id-token: write` and `security-events: write` to the analysis job. Follow the
   action's [publication restrictions](https://github.com/ossf/scorecard-action#workflow-restrictions).
   A score or successful scan is evidence about its checks, not security
   certification. Check the publication outcome as well as workflow success.
6. **Binary release evidence.** Repositories shipping binaries (`rust-mirror`,
   `rust-mirror-gui`) attach an SBOM to each release and attest it with pinned
   `actions/attest-sbom`. Generate CycloneDX with `cargo-cyclonedx` installed using
   `--locked` at a pinned version, or export GitHub dependency-graph SPDX. Refactor
   binary builds into a reusable workflow to meet GitHub's documented
   [SLSA Build Level 3 provenance requirements](https://docs.github.com/en/actions/how-tos/secure-your-work/use-artifact-attestations/increase-security-rating).
   Verify those requirements before claiming the level. Build twice in clean
   environments and compare hashes; record exact inputs, results and any
   non-identical outputs and causes honestly. An unexplained difference remains
   a gap. This requirement does not retroactively supply historical evidence.
7. **Crate Trusted Publishing.** Crate repositories add a workflow triggered by
   `v*` tag pushes. The publishing job uses environment `crates-io`, grants
   `id-token: write` only there, obtains a short-lived token through pinned
   `rust-lang/crates-io-auth-action`, and runs `cargo publish --locked` in dependency
   order, verifying each published checksum against the packaged input. Preserve
   the existing process during rollout. The PR must list exactly, for every
   crate: crate name, repository owner `rustcommons`, repository name, workflow
   filename and environment `crates-io`, for owner entry on crates.io. Review and
   environment approval remain required; this baseline is not publication
   authorization. See [Trusted Publishing action guidance](https://github.com/rust-lang/crates-io-auth-action#usage).
8. **README badges.** Put CI, OpenSSF Scorecard, and license badges near the top
   of the root README. Use
   `https://api.scorecard.dev/projects/github.com/rustcommons/REPO/badge`.
   Add crates.io and docs.rs badges where published. Show SLSA 3 only after it is
   actually achieved; add OpenSSF Best Practices only after owner registration.
   Badges must reflect actual state. If no license is declared, say so rather
   than assert a license; do not add a license without owner approval.
9. **Maintainer instructions.** Update primary `AGENTS.md` to require PR-only
   changes to `main`, pinned actions and applicable security tooling gates.
   Preserve the `CLAUDE.md` shim and shared documentation/requirements rules.
   Update requirements and trace links alongside controls. Record any exception
   explicitly with its scope, evidence and unresolved gap.

## Applicability and validation for `.github`

This repository contains documentation, branding and GitHub Actions; it has no
Cargo project, published crate or binary release. Items 1, 2, 3, 5, 8 and 9 apply.
Items 4, 6 and 7 are **Not applicable** here. No cargo-deny policy, SBOM,
Trusted Publishing workflow, crate badges or SLSA badge is fabricated for it.
No license file is currently declared; the README badge states this limitation.
Public profile text and branding assets are unchanged by this baseline.

Implementation: [Dependabot](../.github/dependabot.yml),
[zizmor](../.github/workflows/security.yml),
[Scorecard](../.github/workflows/scorecard.yml),
[LF check](../.github/workflows/line-endings.yml),
[README](../README.md), [AGENTS](../AGENTS.md), and
[requirements index](REQUIREMENTS.md). All checkout steps disable persisted
credentials; zizmor uses plain CLI results without a write token on PRs.
Actions version updates have a seven-day Dependabot cooldown to satisfy the
workflow audit; the weekly cadence and five-PR limit still apply.

Before merge, inspect action SHA/tag correspondence, workflow syntax and token
scope, local/remote links, rendered Markdown, LF-only text and `git diff --check`.
Require green `lf-only` and `zizmor` PR runs. Scorecard runs only on `main` pushes
and the weekly schedule; its first publication/SARIF upload remains a post-merge
bootstrap check, not a claim supported by PR CI. Do not bypass the PR requirement
for that bootstrap. Check results and retain real gaps before reporting rollout
complete. Update this record and the requirements index when evidence changes.
