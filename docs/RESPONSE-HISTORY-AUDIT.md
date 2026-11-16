# Response-history audit — 2026-11-16

This is a dated, read-only audit of public GitHub response evidence for the nine
Rust Commons repositories, not a promise of future response performance.
[Machine-readable observations](evidence/response-history-2026-11-16.json) retain
endpoints, pinned default-branch revisions, pagination counts, classifications and
scope limits. No issues, comments, settings or product repositories were changed.

## Window and method

The selected OpenSSF public bug/enhancement response window is the **trailing two
calendar months**, from **2026-09-16T05:43:24.234810Z** through **2026-11-16T05:43:24.234810Z**,
inclusive. This includes recent reports; it does not exclude the most recent two
months. It is a permitted window length within the criteria's 2–12 month range.
The [passing criteria](https://www.bestpractices.dev/en/criteria/0?details=true&rationale=true)
and [pinned criteria definitions](https://github.com/ossf/best-practices-badge/blob/31325acd7963e0c9203da0ff798802a766237517/config/locales/en.yml)
are the interpretation sources.

For every repository, request `/repos/rustcommons/REPO/issues` with `state=all`,
ascending creation order and `per_page=100`, following numbered pages through the
first page with fewer than 100 records. GitHub's endpoint also returns PRs: keep
those counts separate. Inspect PR account type/author association to distinguish
maintainer change proposals and automation from public issue reports; do not
count a release or dependency-update PR as a public bug acknowledgment. No
unclassified PR actors appeared in the inspected metadata. All returned public
issue history contained zero issues, so there were no issue bodies or responses
to classify as bugs, enhancements or other requests.

This is an API-visible GitHub-channel audit. Deleted/transferred issues,
off-platform messages and private report conversations are not established by
these results. PR metadata classification is not an audit of every PR discussion.
The [default contribution guide](../CONTRIBUTING.md) directs new public bug and
feature requests to the affected repository's Issues and security reports to
private reporting.

## Public issue results

| Repository | All-state public issues | Bugs / enhancements / other in window | Acknowledgments / responses in window | Maintainer / automated PRs excluded |
| --- | --- | --- | --- | --- |
| [.github](https://github.com/rustcommons/.github/issues) | 0 | 0 / 0 / 0 | 0 / 0 | 11 / 0 |
| [cargo-libc](https://github.com/rustcommons/cargo-libc/issues) | 0 | 0 / 0 / 0 | 0 / 0 | 32 / 4 |
| [linux-abi-tools](https://github.com/rustcommons/linux-abi-tools/issues) | 0 | 0 / 0 / 0 | 0 / 0 | 21 / 2 |
| [glibc-abilists](https://github.com/rustcommons/glibc-abilists/issues) | 0 | 0 / 0 / 0 | 0 / 0 | 12 / 0 |
| [glibc-provider](https://github.com/rustcommons/glibc-provider/issues) | 0 | 0 / 0 / 0 | 0 / 0 | 10 / 2 |
| [rust-musl-libc-compat-test](https://github.com/rustcommons/rust-musl-libc-compat-test/issues) | 0 | 0 / 0 / 0 | 0 / 0 | 8 / 2 |
| [rust-mirror](https://github.com/rustcommons/rust-mirror/issues) | 0 | 0 / 0 / 0 | 0 / 0 | 55 / 10 |
| [rust-mirror-gui](https://github.com/rustcommons/rust-mirror-gui/issues) | 0 | 0 / 0 / 0 | 0 / 0 | 23 / 2 |
| [cargo-binpack](https://github.com/rustcommons/cargo-binpack/issues) | 0 | 0 / 0 / 0 | 0 / 0 | 5 / 0 |

The excluded PR totals are 177 maintainer proposals and 22 automation updates
(199 overall); the observed public issue count across all nine repositories is
zero. Both `rust-mirror` and `rust-mirror-gui` therefore have **empty observed public
issue windows**, rather than demonstrated response-time or response-rate samples.
For the proposed `report_responses` and `enhancement_responses` answers, use Met
with the explicit zero-report denominator and this audit link. Do not describe the
undefined response rate as 100%, or claim that these data prove private or
external-channel response performance. Reassess if an eligible report is identified.

## Private vulnerability response window

The separate six-month criterion window is **2026-05-16T05:43:24.234810Z** through
**2026-11-16T05:43:24.234810Z**, inclusive. The visible advisory inventory has one rust-mirror
advisory and zero in the other eight repositories. The known
[GHSA-46c8-w6pp-97pw](https://github.com/rustcommons/rust-mirror/security/advisories/GHSA-46c8-w6pp-97pw)
was published at 2026-11-16T05:35:02Z; affected rust-mirror `<= 0.5.2`, patched crate
`0.5.3`, first patched downloads `0.5.4`. The assurance record preserves its earlier
pre-publication observation as history.

An advisory's creation/publication time does **not** establish private report
receipt, first acknowledgment or that no other private reports were received.
Consequently `vulnerability_report_response` remains **Unmet — evidence pending**,
not Met from a response target or N/A from an empty public tracker.

To close it at review, the responsible maintainer must check the documented
private channel and any other received reports for the six-month window. Supply
a sanitized record of report count and receipt/first-response UTC dates; every
applicable initial response must be within 14 days. If there were zero applicable
reports, explicitly confirm that fact and the channels/window checked, then use
N/A as the criterion permits. Do not publish report contents, reporter identity
or secrets. The policy's three-business-day target is not this historical proof.

## Default-guide applicability

At the pinned baseline revisions, none of the nine default-branch trees had a
`CONTRIBUTING` override (with or without a filename extension) in `.github/`,
repository root or `docs/` (case-insensitive basename check). The new root guide in the public `.github` repository becomes
the default after this PR merges; it is not claimed live on main before then.
It does not get copied into product clones or packages, and a later per-repository
override takes precedence. See [GitHub's default-file rules](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file).
No product-source or published-package change follows from this policy addition.

## Maintenance

Preserve this window and its negative/empty outcomes as a historical snapshot.
Repeat a dated audit before badge submission if new reports arrive or the chosen
window is no longer current. Record classifications and actual first responses;
do not silently replace counts or turn an empty window into a performance claim.
The [proposed answers](BEST-PRACTICES-ANSWERS.md) track owner-attestation items and
remaining technical/evidence gaps separately.
