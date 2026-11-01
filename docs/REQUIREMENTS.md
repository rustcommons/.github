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
| ORG-REQ-008 | Keep a shared maintainer convention and stable repo-scoped requirements index; current documentation traceability instruction and shared AGENTS section. | [Conventions](DOCUMENTATION.md), this index, root maintainer links, AGENTS shared section. | 2026-11-01 inspection of exact table columns, required sections, status vocabulary, prefix map, and local links; Markdown render and diff checks recorded in PR. | Verified: this repository's index and convention only; other repositories' adoption and independent review remain pending. |
| ORG-REQ-009 | Keep edits scoped to authorized documentation, preserve historical release evidence, and avoid settings, dependency, CI, asset, or release changes; AGENTS scope, validation, and publication rules plus current task constraints. | This documentation-only candidate; shared convention's release/evidence rules. | 2026-11-01 changed-path and full diff review against `dd9ca1a`; only README, AGENTS, and docs files change. | Verified: candidate diff boundary only; account settings and linked repository releases were not audited or modified. |

## Documentation map

- [README](../README.md): repository purpose and maintainer entry point; no
  installation, runtime prerequisites, or linkage applies here.
- [Public profile](../profile/README.md): organization scope and project/guide
  links, not implementation or compatibility certification.
- [Documentation conventions](DOCUMENTATION.md): maintained cross-repository
  reader paths, evidence rules, and adoption snapshot.
- [AGENTS](../AGENTS.md): primary maintainer instructions;
  [CLAUDE](../CLAUDE.md): authority shim.
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
