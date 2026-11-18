# Organization documentation requirements

## Scope and sources

This index covers the `.github` documentation repository, its public profile,
branding assets, and maintenance constraints. It adds no software or platform
support. Primary sources are [AGENTS.md](../AGENTS.md), the established
[root README](../README.md), [public profile](../profile/README.md), and assets
at baseline commit `dd9ca1afbc20a2077ae8176efebce59679f9110b`, plus the shared
[documentation conventions](DOCUMENTATION.md) introduced by this change.

Evidence below is documentation inspection on 2026-11-01 against that baseline
and this candidate change. It verifies only the named document properties, not
any linked project's behavior or runtime compatibility. The PR records the exact
candidate revision and validation commands. No legacy requirement IDs existed
in the baseline; retain these IDs for subsequent changes.

## Requirements

| ID | Requirement and source | Implementation / documentation | Verification evidence | Status and gaps |
| --- | --- | --- | --- | --- |
| ORG-REQ-001 | Keep organization branding and both README headings `# 🦀 Rust Commons`; established baseline READMEs and assets. | [Root README](../README.md), [profile](../profile/README.md). | 2026-11-01 inspection of both first lines and 160px image width/height against baseline `dd9ca1a`; profile diff is empty. | Verified: document headings and image dimensions only; no organization settings audit. |
| ORG-REQ-002 | Introduce Linux compatibility and offline Rust development without claiming released offline tooling; AGENTS Repository purpose and scope. | [Profile introduction](../profile/README.md). | 2026-11-01 source inspection and empty profile diff against `dd9ca1a`. | Verified: retained wording only; offline implementation verification is Not applicable to this repository. |
| ORG-REQ-003 | List four published ABI/libc projects, preserve dependency direction and keep the musl probe separate; AGENTS Repository purpose and scope. | [Profile project table and dependency explanation](../profile/README.md). | 2026-11-01 inspection of the four table entries, dependency paragraph, and separate Compatibility testing heading at `dd9ca1a`; profile unchanged. | Verified: profile structure and names; linked projects' implementation and release audits are outside this evidence. |
| ORG-REQ-004 | Distinguish static inspection and kernel simulation from actual target testing; AGENTS Repository purpose and scope. | [Profile limitations and guide links](../profile/README.md). | 2026-11-01 inspection of explicit target-testing limitation and guide links at `dd9ca1a`; profile unchanged. | Verified: limitation remains documented; runtime certification is Not applicable. |
| ORG-REQ-005 | Exclude mirror/package-management placeholders and speculative features from the public profile pending naming decisions; AGENTS Repository purpose and scope. | [Public profile](../profile/README.md); shared convention's prefix table is maintainer documentation only. | 2026-11-01 inspection of profile table and separate testing entry; empty profile diff against `dd9ca1a`. | Verified: no placeholder profile listings; naming decisions remain pending. |
| ORG-REQ-006 | Preserve editable SVG, transparent 512px PNG and preview companion, with 160px README rendering; established baseline assets and READMEs. | [SVG](../assets/rust-commons.svg), [PNG](../assets/rust-commons.png), [preview](../assets/rust-commons-preview.png). | 2026-11-01 SVG viewBox and PNG IHDR inspection; byte comparison with `dd9ca1a`; README image attributes inspected. | Implemented—partial verification: source dimensions and asset preservation checked; PNG alpha-channel presence alone does not verify every transparent pixel or visual appearance. |
| ORG-REQ-007 | AGENTS is primary, CLAUDE is a short shim; preserve existing Working/Git conventions and prohibit attribution; AGENTS Working, Documentation validation, and Git conventions. | [AGENTS.md](../AGENTS.md), [CLAUDE.md](../CLAUDE.md). | 2026-11-01 exact baseline comparison of Working conventions, Git conventions, and CLAUDE shim; inspect added shared section and doc links. | Verified: instruction authority and unchanged convention blocks; no nested instruction files in tracked baseline. |
| ORG-REQ-008 | Keep a shared maintainer convention and stable repo-scoped requirements index; current documentation traceability instruction and shared AGENTS section. | [Conventions](DOCUMENTATION.md), this index, root maintainer links, AGENTS shared section. | 2026-11-01 inspection of exact table columns, required sections, status vocabulary, prefix map, and local links; Markdown render and diff checks recorded in PR. | Verified: this repository's index and convention only; the [dated adoption record](ADOPTION.md) now records all eight merged indexes and bounded structural/review evidence; per-requirement legal, platform and partial-verification gaps remain. |
| ORG-REQ-009 | Keep edits scoped to authorized documentation, preserve historical release evidence, and avoid settings, dependency, CI, asset, or release changes; AGENTS scope, validation, and publication rules plus current task constraints. | This documentation-only candidate; shared convention's release/evidence rules. | 2026-11-01 changed-path and full diff review against `dd9ca1a`; only README, AGENTS, and docs files change. | Verified: candidate diff boundary only; account settings and linked repository releases were not audited or modified. |
| ORG-REQ-010 | Keep consistent changelogs, user-facing notes, GitHub Releases and release-completion checks for shipped software; maintainer instruction on 2026-11-02. | [Release convention](RELEASING.md), [shared instructions](../AGENTS.md#release-documentation), and per-repository changelog/notes/checker adoption. | [Completed rollout](RELEASING.md#completed-rollout-2026-11-02): eight exact instruction blocks, four identical checker/workflow copies, 20 live notes and four successful full-verification runs; profile/assets unchanged. | Verified: documentation rollout and bounded live-release checks only; historical evidence gaps remain explicit and runtime behavior was not requalified. |
| ORG-REQ-011 | Keep a maintained current cross-repository release/dependency matrix, preserving historical snapshots and distinguishing producer publication from consumer delivery. Source: maintainer coordination request, 2026-11-08. | [Current release status](RELEASE-STATUS.md), [coordination instructions](../AGENTS.md#release-coordination), [release convention](RELEASING.md). | Live eight-repository/registry/source comparison, exact archive/tag/docs checks, stable requirement counts, shared-rule/checker comparison and bounded local synchronization recorded for this change. | Implemented—partial verification: current coordination facts only; Cargo 0.7.0 registry/tag/docs/installed/Release checks are recorded complete; no linked runtime gap is certified. |
| ORG-REQ-012 | Provide an organization default security policy: latest releases, private reporting, response targets, coordinated disclosure, scope and bounded release verification. Source: owner-approved security baseline, 2026-11-15. | [SECURITY.md](../SECURITY.md), [baseline](SECURITY-BASELINE.md). | 2026-11-15 policy/source and command review; read-only GitHub API confirms private reporting enabled here; exact candidate and CI recorded in the PR. | Implemented—partial verification: policy and reporting configuration here; future response performance and other products' release provenance are not certified. |
| ORG-REQ-013 | Apply baseline items 1, 2, 3, 5, 8 and 9 to this repository, document all nine shared items, and require PR-only changes to main; use monthly/two-PR version updates and cancel superseded PR checks. Source: owner-approved security baseline and runner-capacity amendment, 2026-11-15. | [Baseline and validation](SECURITY-BASELINE.md), [Dependabot](../.github/dependabot.yml), [workflows](../.github/workflows), [README](../README.md), [AGENTS](../AGENTS.md#security-baseline). | 2026-11-15 action SHA/tag resolution, permissions/LF/diff/link/render review and PR checks; amendment preserves grouping/cooldown and unconditionally runs LF/zizmor with per-PR concurrency. Read-only ruleset/default-setup API inspection described in baseline. | Implemented—partial verification: PR CI must pass; main-only Scorecard publication/SARIF needs named run evidence, not an inference from PR CI. Rust dependencies, binary evidence and crate publication are Not applicable; the later owner-approved Apache-2.0 declaration is traced in ORG-REQ-016. |
| ORG-REQ-014 | Maintain a factual disconnected-network security assurance report, source-derived PDF and proposed passing-level Best Practices answers for rust-mirror/rust-mirror-gui. Source: owner-approved report/preparation request, 2026-11-15/16. | [Assurance source](SECURITY-ASSURANCE.md), [PDF](SECURITY-ASSURANCE.pdf), [rendering guide](security-assurance/README.md), [dated observations](evidence/security-assurance-2026-11-16.json), [proposed answers](BEST-PRACTICES-ANSWERS.md). | 2026-11-16 pinned source/eval inspection, read-only API/run/registry observations, seven live CLI 0.5.4 provenance checks and five exact SBOM bindings; Mermaid/PDF rendering, extracted text, links and diff checks; exact candidate/CI in PR. | Implemented—partial verification: bounded report and 67 proposed criterion answers, not product certification or an awarded badge. Unmet/unverified criteria, SBOM minimum-element gaps and platform/deployment limits remain explicit; no product/setting/release changes. |
| ORG-REQ-015 | Provide a default contribution/PR guide with automated tests for major new functionality, an honest organization response-history audit, and exact pending primary-developer knowledge attestations. Source: owner-approved report review follow-up, 2026-11-16. | [CONTRIBUTING](../CONTRIBUTING.md), [response audit](RESPONSE-HISTORY-AUDIT.md), [audit observations](evidence/response-history-2026-11-16.json), [pending attestations](BEST-PRACTICES-ANSWERS.md#owner-attestations-still-required). | 2026-11-16 all-state paginated Issues/PR metadata and contributing-override tree checks across nine repositories; zero public issues, 177 maintainer/22 automation PRs; all 67 answer IDs retained; Markdown/PDF/source/diff checks and exact PR CI. | Implemented—partial verification: inherited guide visibility needs merge; empty public windows do not prove a response rate or private history. Private response timing and both developer knowledge attestations remain pending; no badge registration or product edits. |
| ORG-REQ-016 | Keep CI active for all commits/merges, pin workflow installations with integrity checks, document applicable ClusterFuzzLite coverage, and license this repository Apache-2.0. Source: owner-approved 2026-11-17 maintenance decision. | [LICENSE](../LICENSE), [badge](../README.md), [primary rules](../AGENTS.md), [contribution guide](../CONTRIBUTING.md), [baseline/audit](SECURITY-BASELINE.md). | 2026-11-18 source scan of three workflows/six action uses, SHA/tag/entrypoint and zizmor wheel-lock inspection, license byte comparison with the product source, Markdown/links/diff checks and exact PR CI. | Implemented—partial verification: direct actions pinned and zizmor version/hash lock explicit; Scorecard's transitive mutable image remains an upstream publication constraint, documented rather than declared fixed. ClusterFuzzLite is Not applicable to this non-parser documentation repository. Main-only Scorecard License results follow merge, not PR CI. |

## Documentation map

- [README](../README.md): repository purpose and maintainer entry point; no
  installation, runtime prerequisites, or linkage applies here.
- [Public profile](../profile/README.md): organization scope and project/guide
  links, not implementation or compatibility certification.
- [Documentation conventions](DOCUMENTATION.md): maintained cross-repository
  reader paths, evidence rules, architecture-diagram conventions, and adoption
  snapshot. The [diagram conventions](DOCUMENTATION.md#architecture-diagrams)
  require source and requirement links plus inspected render evidence where a
  diagram is applicable; they do not assert that a render proves behavior.
- [Current release matrix](RELEASE-STATUS.md): maintained published versions, source/consumer hand-off, current requirement counts and deferred-work boundaries; not runtime qualification.
- [Release documentation convention](RELEASING.md): changelog/note structure, release completion, safe historical backfill and checks; not a software release for this profile repository.
- [Adoption record](ADOPTION.md): dated cross-repository index revisions, counts,
  evidence boundaries and remaining gaps; not runtime certification.
- [Architecture diagram audit](ARCHITECTURE-DIAGRAMS.md): dated diagram coverage,
  source/render boundaries and explicit non-applicability for the three
  repositories without an implemented product architecture.
- [AGENTS](../AGENTS.md): primary maintainer instructions;
  [CLAUDE](../CLAUDE.md): authority shim.
- [Disconnected-network assurance](SECURITY-ASSURANCE.md) and [PDF](SECURITY-ASSURANCE.pdf): dated source/release evidence, trust boundaries and residual risks; [rendering instructions](security-assurance/README.md).
- [Default contribution guide](../CONTRIBUTING.md): organization default obtain/report/PR rules and major-functionality automated-test policy; per-repository overrides take precedence.
- [Response-history audit](RESPONSE-HISTORY-AUDIT.md): dated empty/classified public windows and explicit private-response gaps, with API observations.
- [Best Practices preparation](BEST-PRACTICES-ANSWERS.md): all passing-level criterion proposals with evidence gaps and suggested fixes; no badge registration.
- [Security policy](../SECURITY.md): default organization reporting and release-verification guidance.
- [License](../LICENSE): owner-approved Apache-2.0 terms for this repository.
- [Security baseline](SECURITY-BASELINE.md): shared controls, applicability and bounded rollout evidence.
- [Assets](../assets/rust-commons.svg): editable logo and PNG companions.
- Architecture, product roadmap, runtime reference, dependency/linkage setup,
  and crate release records: Not applicable to this documentation repository.
  Product details and licensing obligations belong to authoritative linked
  projects; this index asserts no new license or software capabilities.

## Maintenance

Preserve `ORG-REQ` and any future legacy IDs; append new IDs without renumbering
or reuse. Update affected rows and links with documentation or scope changes.
Name the exact evidence, revision and date, and retain gaps when checks are
partial. A later validation record supersedes evidence without rewriting its
historical outcome. Keep public profile changes subject to its existing scope
rules. Review other repository adoption separately; this index cannot certify it.
