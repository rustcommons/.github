# Architecture diagram audit

This dated 2026-11-01 follow-up extends the [documentation adoption record](ADOPTION.md)
to architecture diagrams. It covers all eight public repositories. Seven Mermaid
views in the five implemented projects were added or refreshed, checked against
source and existing requirements, rendered by GitHub, and visually inspected.
The containing guides are listed in each project's documentation map.

## Implemented projects

The links below open maintained guides. The reviewed revisions and PRs preserve
the exact source of this audit; later changes require another scoped review.

| Repository | Maintained diagram | Reviewed revision and change | Evidence boundary |
| --- | --- | --- | --- |
| cargo-libc | [Build and execution flow](https://github.com/rustcommons/cargo-libc/blob/main/ARCHITECTURE.md#implemented-build-and-execution-flow) | [4e8d4c3](https://github.com/rustcommons/cargo-libc/commit/4e8d4c3a0579e3858d0904687007b7f863dd3b53), [PR #9](https://github.com/rustcommons/cargo-libc/pull/9) | One rendered view: provider selection, settings export, native host/target isolation, artifact inspection and runner dispatch. Existing CL-REQ links; plain Cargo requires separate inspection. |
| linux-abi-tools | [Workspace APIs](https://github.com/rustcommons/linux-abi-tools/blob/main/docs/ARCHITECTURE.md#implemented-workspace-boundaries) and [provider data flow](https://github.com/rustcommons/linux-abi-tools/blob/main/docs/ARCHITECTURE.md#implemented-provider-data-flow) | [46625f1](https://github.com/rustcommons/linux-abi-tools/commit/46625f1b8e2ee4a726e5890d9565f3a4ae299e1b), [PR #6](https://github.com/rustcommons/linux-abi-tools/pull/6) | Two rendered views: API/data direction and alternative source/container preparation routes. Existing LAT-REQ links. Two SVG banners inspected; the kernel banner now depicts target kernel to profile to simulated answers. |
| glibc-abilists | [Collection flow and trust boundaries](https://github.com/rustcommons/glibc-abilists/blob/main/docs/COLLECTING.md#collection-flow-and-trust-boundaries) | [4bcf00a](https://github.com/rustcommons/glibc-abilists/commit/4bcf00a7421ffbb8454ca9f1e112628a925173e3), [PR #5](https://github.com/rustcommons/glibc-abilists/pull/5) | One rendered view: online/offline tag comparisons, signature verification versus exceptions, check/write modes and embedded-data consumption. Existing GA-REQ links. Exception acceptance proves neither a signature nor a configured key match. |
| glibc-provider | [Architecture and data flow](https://github.com/rustcommons/glibc-provider/blob/main/docs/MAINTAINING.md#architecture-and-data-flow) | [fb08b27](https://github.com/rustcommons/glibc-provider/commit/fb08b273ff12739065add2c71ec7e81f4e30a846), [PR #3](https://github.com/rustcommons/glibc-provider/pull/3) | One rendered view: collection, interface/library metadata, packing, published source library and local rebuilding. Existing GP-REQ links. Compiled provider objects are not shipped by the source package. |
| rust-musl-libc-compat-test | [Runtime dispatch and ordered gates](https://github.com/rustcommons/rust-musl-libc-compat-test/blob/main/DESIGN_NOTES.md#runtime-flow) | [e657db3](https://github.com/rustcommons/rust-musl-libc-compat-test/commit/e657db3ce66f1addcc949d7b47918abbb6184119), [PR #4](https://github.com/rustcommons/rust-musl-libc-compat-test/pull/4) | Two rendered views: version/suite dispatch, kernel-before-security gates, probe outcomes and final output status. Existing MUSL-REQ links. Build provenance remains diagnostic hints, not proof of the compiler or linked musl archive. |

The Cargo banner is a conceptual illustration, not an implementation diagram.
Earlier release screenshots remain dated evidence rather than current
architecture. This audit does not silently update historical records.

## Repositories without an implemented product architecture

| Repository | Diagram applicability and source |
| --- | --- |
| .github | **Not applicable** to product architecture: this repository maintains the organization profile, branding and documentation conventions. [ORG scope and documentation map](REQUIREMENTS.md) link the implemented projects instead of inventing a runtime for this repository. The logo is branding, not an architecture diagram. |
| rustup-offline-mirror | **Not applicable**: the [confirmed placeholder scope](https://github.com/rustcommons/rustup-offline-mirror/blob/cfdbcb91a220ed7de6655cc22bd89354d05b707f/docs/REQUIREMENTS.md) establishes no public runtime implementation or approved product design. Windows-local prototypes remain unreviewed; no speculative mirror architecture is presented as implemented. |
| cargo-binpack | **Not applicable**: the [confirmed placeholder scope](https://github.com/rustcommons/cargo-binpack/blob/031548a1e54313c729ee9145dc60995e3a4ba402/docs/REQUIREMENTS.md) establishes no implementation or approved product architecture. Naming and future design remain separate decisions. |

## Verification and maintenance

Review evidence consists of source/manifest comparison, existing requirement
links, actual GitHub Mermaid render inspection, SVG inspection where applicable,
link/anchor checks and clean diffs. Presentation checks and source inspection do
not qualify runtime behavior. No executable code, dependency, package version,
lockfile or release changed for this diagram follow-up; no new crate publication
is needed for these excluded guide changes. The 126 existing requirement IDs
remain unchanged.

Real old-system tier 3 testing remains deferred. Prebuilt provider distribution
remains gated by legal review. Planned architectures/libcs, collector trust
policy work, and other partial-verification gaps remain as recorded in each
requirements index and roadmap. No diagram arrow delivers those capabilities.

Follow the [diagram conventions](DOCUMENTATION.md#architecture-diagrams) when
components, interfaces or boundaries change. Keep this record as a dated
snapshot and update the maintained views and affected trace links together.
