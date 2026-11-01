# Documentation adoption baseline — 2026-11-01

This dated record follows the [initial 404 observation](DOCUMENTATION.md#adoption-snapshot),
which remains unchanged as historical evidence. All eight repositories have
merged requirements indexes and the common documentation/traceability AGENTS
section. Their indexes contain **126 requirement rows**. This is documentation
process adoption, not runtime verification or implemented roadmap work.

## Repository indexes and revisions

Index links below are pinned to the named merged adoption revision. Commit
links contain the full exact revisions. Reviewed source and merge commits are
separate; GitHub PR metadata, index contents and the common AGENTS section were
checked on 2026-11-01. Subsequent release bookkeeping is linked separately.

| Repository / requirements index | Prefix | Rows | Reviewed source / PR | Merged adoption revision | Boundary or gap |
| --- | --- | --- | --- | --- | --- |
| [.github](https://github.com/rustcommons/.github/blob/c8a0b9c01aae5657dd0ef649bd37b18d81919ce5/docs/REQUIREMENTS.md) | ORG-REQ | 9 | [`2a449e1`](https://github.com/rustcommons/.github/commit/2a449e1aca4f4225d53e2e0efec5ba1e10ef1af0) / [#1](https://github.com/rustcommons/.github/pull/1) | [`c8a0b9c`](https://github.com/rustcommons/.github/commit/c8a0b9c01aae5657dd0ef649bd37b18d81919ce5) | Documentation, profile scope and asset preservation only. |
| [cargo-libc](https://github.com/rustcommons/cargo-libc/blob/8edb9cb290f51135be1a4e6ae595960f8226f832/docs/REQUIREMENTS.md) | CL-REQ | 26 | [`f5e2fab`](https://github.com/rustcommons/cargo-libc/commit/f5e2fabeabf4a97eb147e084005855751adcd9ff) / [#7](https://github.com/rustcommons/cargo-libc/pull/7) | [`8edb9cb`](https://github.com/rustcommons/cargo-libc/commit/8edb9cb290f51135be1a4e6ae595960f8226f832) | Final freshness/bookkeeping revision; historical 0.2.3 and bounded 0.2.4 evidence linked below. |
| [linux-abi-tools](https://github.com/rustcommons/linux-abi-tools/blob/409c9c6ee84fe8ede7ece72fc2d1e28944af65bb/docs/REQUIREMENTS.md) | LAT-REQ | 28 | [`ed4f7c6`](https://github.com/rustcommons/linux-abi-tools/commit/ed4f7c6e39c5aeeeed19b9bb4135acdb0ba0b213) / [#5](https://github.com/rustcommons/linux-abi-tools/pull/5) | [`409c9c6`](https://github.com/rustcommons/linux-abi-tools/commit/409c9c6ee84fe8ede7ece72fc2d1e28944af65bb) | Source/command/CI evidence remains bounded per row; no target runtime certification. |
| [glibc-abilists](https://github.com/rustcommons/glibc-abilists/blob/d0cf8ee40529880373286c500dd22b9c21d79e2c/docs/REQUIREMENTS.md) | GA-REQ | 15 | [`24b6f0a`](https://github.com/rustcommons/glibc-abilists/commit/24b6f0a2ce707f348225730a06f7f835eecb9e0b) / [#3](https://github.com/rustcommons/glibc-abilists/pull/3) | [`d0cf8ee`](https://github.com/rustcommons/glibc-abilists/commit/d0cf8ee40529880373286c500dd22b9c21d79e2c) | Initial adoption; subsequent 0.1.2 release bookkeeping recorded below. |
| [glibc-provider](https://github.com/rustcommons/glibc-provider/blob/2a7a0fafce50b8516208a89c98f7b5023b77ecbf/docs/REQUIREMENTS.md) | GP-REQ | 16 | [`52aa84c`](https://github.com/rustcommons/glibc-provider/commit/52aa84ca4b317e2691d10e5103c217618213ac18) / [#1](https://github.com/rustcommons/glibc-provider/pull/1) | [`2a7a0fa`](https://github.com/rustcommons/glibc-provider/commit/2a7a0fafce50b8516208a89c98f7b5023b77ecbf) | Initial adoption; final 0.1.1 release records confirmed below. |
| [rust-musl-libc-compat-test](https://github.com/rustcommons/rust-musl-libc-compat-test/blob/b10d4c1fa03edb53f85a0af5a93c35ac0a8d74d5/docs/REQUIREMENTS.md) | MUSL-REQ | 19 | [`1659069`](https://github.com/rustcommons/rust-musl-libc-compat-test/commit/1659069a1224f16e7ed076ea0cd63dea2cd97a6e) / [#3](https://github.com/rustcommons/rust-musl-libc-compat-test/pull/3) | [`b10d4c1`](https://github.com/rustcommons/rust-musl-libc-compat-test/commit/b10d4c1fa03edb53f85a0af5a93c35ac0a8d74d5) | Host/probe evidence does not certify all Linux targets. |
| [rustup-offline-mirror](https://github.com/rustcommons/rustup-offline-mirror/blob/cfdbcb91a220ed7de6655cc22bd89354d05b707f/docs/REQUIREMENTS.md) | ROM-REQ | 6 | [`5686413`](https://github.com/rustcommons/rustup-offline-mirror/commit/5686413620fb6302d9be6bf62cc85090488260da) / [#2](https://github.com/rustcommons/rustup-offline-mirror/pull/2) | [`cfdbcb9`](https://github.com/rustcommons/rustup-offline-mirror/commit/cfdbcb91a220ed7de6655cc22bd89354d05b707f) | Placeholder documentation/scope/maintenance only; implementation verification Not applicable. |
| [cargo-binpack](https://github.com/rustcommons/cargo-binpack/blob/031548a1e54313c729ee9145dc60995e3a4ba402/docs/REQUIREMENTS.md) | CB-REQ | 7 | [`c213c46`](https://github.com/rustcommons/cargo-binpack/commit/c213c4693277b0f5af0cc5f16c23ef253cee373f) / [#1](https://github.com/rustcommons/cargo-binpack/pull/1) | [`031548a`](https://github.com/rustcommons/cargo-binpack/commit/031548a1e54313c729ee9145dc60995e3a4ba402) | Placeholder documentation/scope/maintenance only; implementation verification Not applicable. |

## Release-record follow-through

- `glibc-abilists`: initial adoption at
  [`d0cf8ee`](https://github.com/rustcommons/glibc-abilists/commit/d0cf8ee40529880373286c500dd22b9c21d79e2c).
  Subsequent bookkeeping [PR #4](https://github.com/rustcommons/glibc-abilists/pull/4)
  reviewed [`2c3cd71`](https://github.com/rustcommons/glibc-abilists/commit/2c3cd71ea76e9daff2be0789be36cdb58c7521a2)
  and merged as [`e60bbf1`](https://github.com/rustcommons/glibc-abilists/commit/e60bbf11d91807151b929cd87ca9064798dafa73).
  [Release records at that revision](https://github.com/rustcommons/glibc-abilists/tree/e60bbf11d91807151b929cd87ca9064798dafa73/docs)
  bound the 0.1.2 publication, tag and docs.rs rendering evidence. This adoption
  record does not itself re-run package or runtime validation.
- `glibc-provider`: final bookkeeping [PR #2](https://github.com/rustcommons/glibc-provider/pull/2)
  reviewed [`a3ab427`](https://github.com/rustcommons/glibc-provider/commit/a3ab427215fdadbf6e874765c4cbb56264c9c6a0)
  and merged as [`542e434`](https://github.com/rustcommons/glibc-provider/commit/542e434215af4a0b91e22e95257670f0c44ce978),
  retaining 16 requirement rows. The [release records](https://github.com/rustcommons/glibc-provider/tree/542e434215af4a0b91e22e95257670f0c44ce978/docs)
  bound the 0.1.1 tag/source, official payload, docs.rs build, and published README
  status/link-rendering evidence. This central record does not repeat or extend
  those validations.
- `cargo-libc`: [PR #4](https://github.com/rustcommons/cargo-libc/pull/4)
  merged as [`289f28d`](https://github.com/rustcommons/cargo-libc/commit/289f28d161027e86decc808fc1745ec4a5b74d39).
  The reviewed source/package-input candidate was
  [`b40b2de`](https://github.com/rustcommons/cargo-libc/commit/b40b2de58e842d1d274f7882b0396ddb9612eead);
  the final PR head was [`f7330c2`](https://github.com/rustcommons/cargo-libc/commit/f7330c2892745f9ca73f511f572b9b20c52b4293).
  [Registry run 41274081431](https://github.com/rustcommons/cargo-libc/actions/runs/41274081431)
  provides bounded package evidence. Subsequent bookkeeping [PR #5](https://github.com/rustcommons/cargo-libc/pull/5)
  reviewed [`c0b91a5`](https://github.com/rustcommons/cargo-libc/commit/c0b91a5e1fdc2a5f05495cfaccf511f88e1f8dff)
  and merged as [`28977c4`](https://github.com/rustcommons/cargo-libc/commit/28977c405917dc0530414a8490abea9c52480305).
  Its [0.2.3 release record](https://github.com/rustcommons/cargo-libc/blob/28977c405917dc0530414a8490abea9c52480305/docs/RELEASE-0.2.3.md)
  records completed official archive, installation, docs.rs rendering and tag
  checks, including [published-install run 41274796646](https://github.com/rustcommons/cargo-libc/actions/runs/41274796646).
  These are historical 0.2.3 results; that immutable README retained an outdated
  release label. The documentation-only 0.2.4 correction replaced it with a
  version-neutral release-index link. [PR #6](https://github.com/rustcommons/cargo-libc/pull/6)
  reviewed [`53b828c`](https://github.com/rustcommons/cargo-libc/commit/53b828c93115c79ef493c1041770f156f2060ec5)
  and merged as released source [`889515b`](https://github.com/rustcommons/cargo-libc/commit/889515b191ead51303b1321de858ec4e2209722c).
  Final bookkeeping is pinned in the table. Its [0.2.4 release record](https://github.com/rustcommons/cargo-libc/blob/8edb9cb290f51135be1a4e6ae595960f8226f832/docs/RELEASE-0.2.4.md)
  records official checksum/VCS and actual docs.rs README verification;
  [published-install run 41276430527](https://github.com/rustcommons/cargo-libc/actions/runs/41276430527)
  completed successfully at that exact released source. These bounded results
  do not extend runtime support or close the index's legal/platform gaps.

## Evidence boundaries and remaining gaps

Structural/shared-instruction checks passed, with substantive independent review
and a narrow follow-up review. These checks cover index
structure, the common AGENTS section, traceability and documented evidence
boundaries; they do not mean every requirement is Verified or every roadmap item
is implemented. Each pinned index retains its own statuses, named commands,
source references, dates and explicit verification gaps.

Local documentation checks confirmed the listed unique ID counts and total at
the pinned revisions. No new builds, runtime tests or package publications were
performed for this central record. Placeholder implementation verification remains
Not applicable; product naming and public-profile listing decisions remain open.

No index adoption remains pending in this baseline. Legal, partial-verification
and platform gaps remain as stated in the individual indexes. Product release
qualification is separate from index adoption.
Future source or scope changes remain subject to the existing
[documentation conventions](DOCUMENTATION.md); this is a bounded baseline record,
not an ongoing certification or a new policy.
