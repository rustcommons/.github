# Current Rust Commons release status

Maintained coordination page, checked 2026-11-08 UTC. Repository versions are
independent: producer workspace 0.6.0 and cargo-libc 0.6.0 are different releases.
A merged dependency update is not a published consumer update. Registry archives,
immutable source tags and per-repository release records remain authoritative.

The [adoption baseline](ADOPTION.md) and [diagram audit](ARCHITECTURE-DIAGRAMS.md)
are dated historical evidence. Keep their original revisions/counts intact;
this page provides the current hand-off without rewriting those snapshots.

## Repository matrix

| Repository | Delivered version | Current delivery state | Next action / boundary |
| --- | --- | --- | --- |
| [cargo-libc](https://github.com/rustcommons/cargo-libc) | [0.6.0](https://github.com/rustcommons/cargo-libc/releases/tag/v0.6.0) | Released 0.6.0 locks producer 0.5.0. [Main adoption](https://github.com/rustcommons/cargo-libc/commit/b2db2daa13f5658ea406c55e67c59f5e371c7143) requires producer 0.6.0. | [0.7.0 candidate PR26](https://github.com/rustcommons/cargo-libc/pull/26): versioned package/install and publication gates pending. No second 0.6.0 upload. |
| [linux-abi-tools](https://github.com/rustcommons/linux-abi-tools) | [0.6.0 for all five crates](https://github.com/rustcommons/linux-abi-tools/releases/tag/v0.6.0) | [Completed producer record](https://github.com/rustcommons/linux-abi-tools/blob/01676c8eec800d9339058d31f4c3f9e53cdd0fa6/docs/RELEASE-0.6.0.md); official archives, exact source, docs.rs and registry-install checks passed. | No new producer release needed for the current Cargo hand-off. |
| [glibc-abilists](https://github.com/rustcommons/glibc-abilists) | [0.1.2](https://github.com/rustcommons/glibc-abilists/releases/tag/v0.1.2) | Corrected API docs are published. [Current main](https://github.com/rustcommons/glibc-abilists/commit/896783bf4f6e5e48c0954e897b98dfd3b39b003b) adds documentation/infrastructure only. | No unshipped API/data fix established; README release-navigation additions alone do not require another docs release. |
| [glibc-provider](https://github.com/rustcommons/glibc-provider) | [glibc-provider-sources 0.1.1](https://github.com/rustcommons/glibc-provider/releases/tag/v0.1.1) | Corrected packaged README is published; source pack remains unchanged. | No source-pack release needed for this hand-off; compiled prebuilt objects remain legally gated. |
| [rust-musl-libc-compat-test](https://github.com/rustcommons/rust-musl-libc-compat-test) | No versioned release recorded | Maintained standalone probe; fixes/docs merged. | Future release/provenance work is separate; do not invent a crate/tag to align numbers. |
| [.github](https://github.com/rustcommons/.github) | Not applicable | Profile, shared documentation rules and this current matrix. | No software release or runtime compatibility certification. |
| [rustup-offline-mirror](https://github.com/rustcommons/rustup-offline-mirror) | No approved release | GitHub scope remains a placeholder; local prototypes are outside its committed evidence. | Separate implementation review/commit/scope decision before release planning. |
| [cargo-binpack](https://github.com/rustcommons/cargo-binpack) | No approved release | Placeholder, without a release-ready implementation. | Naming/scope/implementation decisions remain separate. |

## Consumer dependency baseline

| Input | Published cargo-libc 0.6.0 lock | 0.7.0 candidate lock | Why |
| --- | --- | --- | --- |
| libc-abi-tools | 0.5.0 | 0.6.0, minimum 0.6.0 | Deliver the immutable provider-generation repair. |
| kernel-abi-tools | 0.3.3 | 0.3.3 | Source/data unchanged through producer 0.6.0; retain existing minimum. |
| linux-abi-scan | 0.3.3 | 0.3.3 | Same bounded scanner implementation; preserve unrelated lock. |
| linux-targets | 0.3.3 | 0.3.3 | Existing 0.3.0 minimum and 0.3.3 lock are deliberate. |
| glibc-abilists | 0.1.2 | 0.1.2 | No ABI data change. |
| glibc-provider-sources | 0.1.1 | 0.1.1 | No source-pack change. |

The [producer comparison](https://github.com/rustcommons/linux-abi-tools/compare/v0.3.3...v0.6.0)
contains no kernel/scanner/targets source/data changes. Different version numbers
therefore do not establish a missing fix. Producer 0.6.0 itself retains upstream
0.1.0 lock entries deliberately; the later input-crate releases were docs-only.
That is distinct from Cargo's consumer lock. Do not republish merely to make all
numbers equal; refresh a real registry graph deliberately and qualify its package.

## Current requirements inventory

The historical adoption baseline contains 126 rows. The maintained indexes below
now contain 140, including the new organization coordination requirement in this
change. Stable IDs retain gaps reserved for unmerged research; do not renumber.

| Repository | Rows | Index checked |
| --- | ---: | --- |
| .github | 11 | [Current organization index](REQUIREMENTS.md) |
| cargo-libc | 30 | [Merged adoption index](https://github.com/rustcommons/cargo-libc/blob/b2db2daa13f5658ea406c55e67c59f5e371c7143/docs/REQUIREMENTS.md) |
| linux-abi-tools | 31 | [Producer index](https://github.com/rustcommons/linux-abi-tools/blob/01676c8eec800d9339058d31f4c3f9e53cdd0fa6/docs/REQUIREMENTS.md) |
| glibc-abilists | 16 | [Index](https://github.com/rustcommons/glibc-abilists/blob/main/docs/REQUIREMENTS.md) |
| glibc-provider | 17 | [Index](https://github.com/rustcommons/glibc-provider/blob/main/docs/REQUIREMENTS.md) |
| rust-musl-libc-compat-test | 20 | [Index](https://github.com/rustcommons/rust-musl-libc-compat-test/blob/main/docs/REQUIREMENTS.md) |
| rustup-offline-mirror | 7 | [Index](https://github.com/rustcommons/rustup-offline-mirror/blob/main/docs/REQUIREMENTS.md) |
| cargo-binpack | 8 | [Index](https://github.com/rustcommons/cargo-binpack/blob/main/docs/REQUIREMENTS.md) |

All eight shared documentation/release AGENTS blocks match. All four release
checkers have SHA-256 `6e666710a350d9c176a5f79a17a7a0ac16f5aeaa0e0801baf0a967485524fdea`.
These are documentation/process observations, not runtime or security proofs.

## Deferred work and release ownership

The LLVM preparation/runtime work and associated upstream checklists remain
drafts: [producer PR10](https://github.com/rustcommons/linux-abi-tools/pull/10),
[Cargo PR14](https://github.com/rustcommons/cargo-libc/pull/14),
[ABI PR8](https://github.com/rustcommons/glibc-abilists/pull/8) and
[provider PR6](https://github.com/rustcommons/glibc-provider/pull/6). No default,
API or release approval follows from this matrix. Existing unwinder coexistence,
old-system/tier 3, musl provenance, collector trust-policy, container-host and
prebuilt legal gaps keep their recorded scopes.

The release owner updates this page when a producer is published, a consumer
minimum is merged, a candidate version is chosen, or registry/Release closeout
completes. Distinguish those stages explicitly. Verify registry checksums and
source tags, final package/install evidence, docs.rs and exact GitHub Release
notes before calling a release complete. Link the authoritative record; do not
turn a successful Markdown check into product qualification.

For local checkout synchronization, first require a clean working tree and the
expected remote/branch, then fast-forward only. Preserve dirty prototypes and
local work. A local manifest version is not proof of registry publication.
