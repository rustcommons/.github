# Rust Commons security baseline

Owner-approved baseline, 2026-11-15; amended for runner capacity and the
2026-11-17 CI coverage, installation-integrity and fuzzing decision.
This is the shared maintainer reference for all Rust Commons repositories. Requirements below describe the required end state;
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
   and, when there is a Cargo project, `cargo`. Use monthly version-update schedules,
   group minor and patch updates, retain cooldowns, and set
   `open-pull-requests-limit: 2` for each ecosystem.
   Cover the actual manifests/workspaces; review major updates separately.
   Security updates remain advisory-triggered, independent of the version-update
   schedule, cooldown and configurable version-PR limit. See the
   [Dependabot reference](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference).
   The amendment supersedes the initial weekly/five-PR version-update policy.
2. **Action identity and permissions.** Pin every third-party action to a full
   commit SHA, including GitHub-maintained actions, with its version tag in a
   trailing comment. Keep workflow-level permissions read-only and grant writes
   only to the job needing them. Disable checkout credential persistence unless
   explicitly needed and justified. Review Dependabot pin updates before merge.
   Pin workflow installations too: pip must use exact versions and hashes for
   the complete requirements set (`--require-hashes`); Cargo tool installation
   must use `cargo install --locked --version X.Y.Z`; container/job/service images
   must use immutable digests. Review transitive action entrypoints as well as
   direct `uses` lines. A SHA-pinned wrapper does not freeze a mutable runtime
   image. Downloaded executables/scripts must have an immutable expected identity
   and verified checksum/signature before execution; no unverified download-and-run.
   Provider-managed hosted-runner labels are not container-image digest pins;
   do not describe the overall environment as hermetic from action pins alone.
   Use explicit hosted-runner OS versions in repository workflows. This
   repository’s checked-in workflows use `ubuntu-24.04`; moving to Ubuntu 26.04 is a deliberate,
   reviewed change with fresh validation, not an automatic label migration.
   An OS-version label still does not freeze GitHub's image patch revision.
   Audit JavaScript action runtimes (including nested actions) before upgrading:
   use a supported Node-24 action major with a full SHA/version comment, read
   release notes and preserve artifact naming/path and credential behavior.
   When Rust toolchain actions apply, use the exact toolchain branch's SHA without
   an ignored `toolchain` input, and confirm `rustc --version` in CI logs.
3. **Workflow linting.** Run [zizmor](https://docs.zizmor.sh/integrations/) on PRs.
   Fix findings or justify narrowly scoped suppressions inline; do not turn off
   the gate to bypass findings. Use unprivileged PR execution, not privileged
   execution of untrusted contributions. Give every repository-defined PR
   workflow a workflow-specific per-PR concurrency group with
   `cancel-in-progress: true`; use a unique run fallback for non-PR events.
   For `dependabot[bot]` PRs keep core checks (fmt, clippy, test, cargo-deny,
   zizmor, lf-only and CodeQL, where applicable), and skip expensive matrices
   or qualification jobs with `if: github.actor != 'dependabot[bot]'` or an
   explicit path/label gate. Required `lf-only` must still run.
   Never use `[skip ci]`, `[ci skip]`, other CI-skip message markers or skip
   trailers in commits or merges, even for documentation-only changes. These can
   suppress CodeQL/applicable CI and reduce observed Scorecard SAST/CI-Tests
   coverage. Keep those checks running; control cost with scoped jobs and
   cancellation, not a commit-message bypass. See
   [GitHub's skip semantics](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/skip-workflow-runs). Inventory open
   Dependabot PRs in the amendment PR: safe patch/minor or MAJOR needing work,
   with a risk note. Do not merge those PRs as part of this rollout.
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
   The org-wide job layout, gate, attestations and release automation are fixed
   by the [standard release pipeline](TRUSTED-PUBLISHING.md).
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


## Fuzzing external input

Repositories that implement parsers for external/untrusted product input must
maintain relevant [ClusterFuzzLite](https://google.github.io/clusterfuzzlite/)
targets, seed valid/invalid inputs and retain crash regressions. Run bounded PR
fuzzing and use separately scoped/scheduled longer runs where configured, respecting
the runner-budget and bot-PR policy above. Pin the fuzzing actions, tool installers
and container images under the same rules; do not solve fuzzing setup by executing
an unverified bootstrap script. Record actual target/input coverage and findings;
a green run is not proof that a parser is safe. A repository without such a parser
records Not applicable and its reason instead of adding a placeholder fuzz job.


## Applicability and validation for `.github`

This repository contains documentation, branding and GitHub Actions; it has no
Cargo project, published crate or binary release. Items 1, 2, 3, 5, 8 and 9 apply.
Items 4, 6 and 7 are **Not applicable** here. No cargo-deny policy, SBOM,
Trusted Publishing workflow, crate badges or SLSA badge is fabricated for it.
The owner authorized an Apache-2.0 [root LICENSE](../LICENSE) on 2026-11-17;
the README badge now links it. Earlier no-license observations remain historical.
The documentation-rendering helper reads maintainer-controlled repository content;
this repository does not ship a product parser for external input. ClusterFuzzLite
is **Not applicable** here, not an unrun fuzzing pass.
Public profile text and branding assets are unchanged by this baseline.

Implementation: [Dependabot](../.github/dependabot.yml),
[zizmor](../.github/workflows/security.yml),
[Scorecard](../.github/workflows/scorecard.yml),
[LF check](../.github/workflows/line-endings.yml),
[README](../README.md), [AGENTS](../AGENTS.md), and
[requirements index](REQUIREMENTS.md). All checkout steps disable persisted
credentials; zizmor uses plain CLI results without a write token on PRs.
Actions version updates have a seven-day Dependabot cooldown to satisfy the
workflow audit; the amended monthly cadence and two-PR limit apply to version
updates. Both repository-defined PR workflows cancel superseded runs of the same
workflow and PR; `lf-only` and zizmor have no bot skip condition. There are no
expensive PR jobs here. Scorecard runs only on main/weekly; CodeQL is managed by
GitHub default setup, with no checked-in workflow to amend.

Before merge, inspect action SHA/tag correspondence, workflow syntax and token
scope, local/remote links, rendered Markdown, LF-only text and `git diff --check`.
Require green `lf-only` and `zizmor` PR runs. Scorecard runs only on `main` pushes
and the weekly schedule. Verify License results, publication and SARIF upload on
the applicable post-merge main run; PR CI cannot establish those outcomes. Do not
bypass the PR requirement or suppress CI for that check. Retain real gaps before
reporting rollout complete, and update the requirements index when evidence changes.

## Workflow-installation audit — 2026-11-18

The three checked-in workflows have six direct action invocations using four
SHA-pinned upstream action identities. There are no direct pip/Cargo installers,
job/service containers or download-and-run shell installers in these workflows.
No existing documentation recommended a CI-skip message convention; the new rules
prohibit future use. Past commit messages and dated evidence are not rewritten.

The zizmor action now explicitly selects 1.32.0. Its pinned
[installer](https://github.com/zizmorcore/zizmor-action/blob/45d7276c9ca790aabd705e31ca99c6185c3e76dd/action.sh)
uses pip download with `--require-hashes`, `--no-deps` and `--only-binary`, against
its [versioned wheel lock](https://github.com/zizmorcore/zizmor-action/blob/45d7276c9ca790aabd705e31ca99c6185c3e76dd/support/locks/zizmor-1.32.0.txt).
That lock matches this action revision's former default lock; making the selector
explicit does not change the verified tool version or bypass hash checking.

**Remaining transitive pinning gap:** the official SHA-pinned Scorecard v2.5.0
[action metadata](https://github.com/ossf/scorecard-action/blob/fa7117db83c52d787ae5a89f350999701505d78e/action.yaml)
selects `docker://ghcr.io/ossf/scorecard-action:v2.5.0`, a mutable image tag.
The current upstream publication
[validator](https://github.com/ossf/scorecard-infra/blob/6cbe75a7c647ca59294477dd803666a19463ccc5/api/app/server/verify_workflow.go)
parses an `@digest` Docker reference as an unapproved step name, so replacing
this step with a direct digest reference is not a verified way to preserve
`publish_results: true`. The existing official publication path is retained;
this is an unresolved upstream constraint, not an exception that makes the
strict image-pinning requirement satisfied. Resolve it through a supported
immutable entrypoint/publication path before claiming every transitive runtime
is pinned. PR CI cannot prove a main-only Scorecard publication outcome.

## CI annotation audit — 2026-11-21

Latest completed main runs at `658d12682f8073313c29c8eb2ae55a0ac156597d`:
Scorecard [44236809983](https://github.com/rustcommons/.github/actions/runs/44236809983),
managed CodeQL [44236809857](https://github.com/rustcommons/.github/actions/runs/44236809857),
LF [44236809894](https://github.com/rustcommons/.github/actions/runs/44236809894), and
zizmor [44236809921](https://github.com/rustcommons/.github/actions/runs/44236809921).
Each had one Ubuntu 26 migration **notice** and no warning/failure annotations.
No Node 20 deprecation was present. The
[observation record](evidence/ci-warnings-2026-11-21.json) preserves those annotations,
action runtime identities and release-note references. PR-after counts belong to
the completed PR check annotations; no green or zero-warning result is inferred
before execution.

All checked-in JavaScript action uses already run Node 24: checkout v7.0.1 and
CodeQL upload-sarif v4.39.3; zizmor's pinned composite also references Node-24
upload-sarif v4.39.1. Scorecard is a Docker action. Existing SHA/version pins stay
unchanged because no Node-20 action upgrade is needed. Checkout explicitly keeps
`persist-credentials: false`, including after its credential-storage changes;
there are no artifact upload/download actions to migrate as a pair.

All three repository-defined jobs now select Ubuntu 24.04. The managed CodeQL
default setup separately reports `runner_type: standard`, `runner_label: ""`.
Its generated `Analyze (actions)` workflow is not a checked-in workflow, so its
provider-generated migration notice is not changed by this PR. No repository or
organization settings are changed. Report that remaining managed notice separately
rather than count it as fixed by a YAML edit.

There is no Rust toolchain action, Rust job or release/dry-run workflow in this
documentation repository. Rust version-log comparison and a release dry run are
Not applicable; no dummy Rust build or release qualification was added. Scorecard
still runs only on main/schedule; its changed runner needs a post-merge main run.
The open-PR inventory was empty, so no Dependabot PR was superseded or closed.
