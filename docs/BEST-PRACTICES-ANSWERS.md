# Proposed OpenSSF Best Practices passing answers

Updated 2026-11-22 (initial preparation 2026-11-16) for **rust-mirror** and **rust-mirror-gui**. These are review
inputs, not a registration, awarded badge, developer attestation or claim that
passing is achieved. No changes to either product repository are part of this
preparation.

Coverage: all **67** passing-level criterion IDs from the
[OpenSSF criteria source at 31325acd7963e0c9203da0ff798802a766237517](https://github.com/ossf/best-practices-badge/blob/31325acd7963e0c9203da0ff798802a766237517/criteria/criteria.yml).
Consult the [official passing form/details](https://www.bestpractices.dev/en/criteria/0)
when entering answers; MUST/SHOULD/SUGGESTED differ, and some criteria restrict N/A.
IDs below retain the form’s identifiers rather than paraphrasing its legal wording.

## Owner registration steps

1. Sign in at <https://www.bestpractices.dev> with GitHub.
2. Add each project by its repository URL: <https://github.com/rustcommons/rust-mirror>
   and <https://github.com/rustcommons/rust-mirror-gui>.
3. Paste the proposed answers below, including their evidence boundaries and any
   remaining Unmet answers. Recheck live alerts before submitting.
4. Publish the two truthful [primary-developer attestation statements](#owner-attestations-still-required)
   at a public URL and link it as justification. Unfilled templates are not evidence.
5. Add a badge to each README only after the site awards it.

The default [CONTRIBUTING guide](../CONTRIBUTING.md) is now on main
([merge 8b807297](https://github.com/rustcommons/.github/commit/8b8072975a2f21ea709cb0962f61f3f6c9daee17)).
It requires automated tests for major new functionality. The historical
[response audit](RESPONSE-HISTORY-AUDIT.md) remains dated; the refresh below
records a subsequent public issue without rewriting that empty-window snapshot.

**Met** means the linked evidence supports the proposed bounded answer.
**Unmet** conservatively includes an actual missing practice **or evidence not yet
established**; it is not an assertion that every such control is absent. Each such
row has a fix or evidence-collection suggestion. **N/A** is used only with a stated
scope and where the source permits it. Do not turn an unknown into N/A.

## Source boundaries and dated history

| Product | Current released source | Separate repository-maintenance boundary |
| --- | --- | --- |
| rust-mirror 0.6.1 | [`3c11d914bce9a06cb92ef7f39179e3a42f98cab0`](https://github.com/rustcommons/rust-mirror/tree/3c11d914bce9a06cb92ef7f39179e3a42f98cab0) | Main observed at [`b14ca618ee6d043eac979a7d50b3f9fa6d4701ab`](https://github.com/rustcommons/rust-mirror/tree/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab); `url` 2.5.9 and unified `actions/attest` are maintenance **after** the release. |
| rust-mirror-gui 0.5.4 | [`06927ece4f1fadc59f2ef015d7c21bf950da0630`](https://github.com/rustcommons/rust-mirror-gui/tree/06927ece4f1fadc59f2ef015d7c21bf950da0630); compiled engine rust-mirror 0.6.1 | Main equals that released source at observation; its own lock includes `url` 2.5.9 and its signer already uses unified `actions/attest`. |

The read-only [2026-11-22 API evidence](evidence/best-practices-2026-11-22.json)
records endpoints, observation time, revisions, alert counts and selected run/log
outcomes. No product, workflow, setting, advisory, alert disposition or badge was
changed. Counts are a point-in-time inventory, not a continuous monitoring claim.

Both products now use the standard phase 2 tag pipeline: gate, isolated reusable
build/sign, owner-approved crates.io publication, GitHub release, public verification.
[CLI run 44992707987 attempt 2](https://github.com/rustcommons/rust-mirror/actions/runs/44992707987/attempts/2)
and [GUI run 45070738820](https://github.com/rustcommons/rust-mirror-gui/actions/runs/45070738820)
completed successfully at the release revisions above. The
[CLI publication record](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/docs/evals/2026-11-22-publication-0.6.1.md)
records the initial CI-gate refusal as well as successful rerun, nine assets,
seven checksum entries, eight provenance subjects and six SBOM bindings.
[GUI release notes](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md)
describe eight assets, six checksum entries, seven provenance subjects and five
SBOM bindings (four archives plus crate). Both attach `.intoto.jsonl` bundles,
CycloneDX SBOMs and SHA256SUMS. These are SLSA Build L3 workflow-design/reusable-signer
and successful pipeline verification evidence, not independent certification or
universal reproducibility; this refresh did not download/reverify each artifact.
The [CLI current signer](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/.github/workflows/build-binaries.yml)
and [GUI released signer](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/build-binaries.yml)
use SHA-pinned `actions/attest` v4.2.2. CLI **0.6.1 itself** used the earlier
SBOM wrapper and retained its deprecation notice; current-main migration does not
rewrite its immutable workflow or artifacts.

Historical baseline, 2026-11-16: CLI 0.5.4 source `b254027cd8a31ebadd92f712671ed0d76c28561a`;
GUI 0.5.0 source `3ac3b8978acb44752a341ebecde057cd50b1b88f` (engine 0.5.1), with policy source
`af94a31894d2e052c4044ed24a0506d854e14b2e`. The [assurance report](SECURITY-ASSURANCE.md), PDF,
[observations](evidence/security-assurance-2026-11-16.json) and
[response audit](RESPONSE-HISTORY-AUDIT.md) retain that date and their original
limits (including GUI 0.5.0's lack of SBOM/L3). They are not current-release audits.

## Evidence refresh — 2026-11-22

### Cryptographic configuration

[Released engine network.rs:585–615](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/src/network.rs#L585)
constructs rustls with `crypto::ring::default_provider()` and
`with_safe_default_protocol_versions()`; certificate-verification delegation is
retained even in the recording verifier. [Engine lib.rs:354–355](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/src/lib.rs#L354)
uses the `sha2` library's SHA-256 for integrity. No project cipher, key exchange or
random-number algorithm is implemented here. [GUI Cargo.lock](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/Cargo.lock)
resolves engine 0.6.1, rustls 0.23.46 and ring 0.17.14; its worker executes that
compiled engine ([ops.rs](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/src/ops.rs)).

The exact rustls [ring provider](https://github.com/rustls/rustls/blob/f04804fa13341a9b1dc02b5d1dd8a746f2c4b7fb/rustls/src/crypto/ring/mod.rs)
selects AES-128/256-GCM or ChaCha20-Poly1305, SHA-256/384, ECDHE for TLS 1.2,
TLS 1.3 ephemeral key exchange, P-256/P-384/X25519 groups, and RSA verification
with a 2048-bit minimum. Its [default versions](https://github.com/rustls/rustls/blob/f04804fa13341a9b1dc02b5d1dd8a746f2c4b7fb/rustls/src/versions.rs)
are TLS 1.3 and (when enabled) TLS 1.2; no TLS 1.0/1.1, MD5, RC4 or CBC suite is
in that default list. These meet or exceed the criterion's 112-bit symmetric, 2048-bit RSA,
224-bit curve and 224-bit hash minima. Weaker suites/versions are already excluded;
there is no project option to enable them. This describes library defaults, not a
measurement of every customer's server certificate or negotiated connection.

The provider's `SecureRandom::fill` calls ring `SystemRandom`, whose
[implementation](https://github.com/briansmith/ring/blob/2723abbca9e83347d82b056d5b239c6604f786df/src/rand.rs#L162)
uses `getrandom` and OS randomness on the supported native targets. The published
ring 0.17.14 archive SHA-256 matches both locks, and its `src/rand.rs` was compared
byte-for-byte with that linked source (the archive's overall VCS metadata says
`dirty`; no claim of whole-archive Git equality). The separate fuzz tool's random
inputs and fixture keys are not production TLS entropy. Dependency delegation
does not prove absence of all crypto defects or independent upstream authentication.

### Alerts and static-analysis disposition

Initial inventory (historical; the CodeQL follow-up below supersedes its open
CodeQL counts): read-only paginated `secret-scanning/alerts?state=open`,
`code-scanning/alerts?state=open` and `dependabot/alerts?state=open` inventories:

| Repository | Secret scanning / push protection | Open secret alerts | Open CodeQL (critical / high / medium / low) | Open Scorecard (critical / high / medium / low) | Open Dependabot / older than 60 days |
| --- | --- | --- | --- | --- | --- |
| rust-mirror | enabled / enabled | 0 | 6 / 6 / 0 / 0 | 0 / 2 / 0 / 1 | 0 / 0 |
| rust-mirror-gui | enabled / enabled | 0 | 13 / 0 / 0 / 0 | 0 / 4 / 0 / 1 | 0 / 0 |

CodeQL default setup is configured weekly for Actions, Python and Rust in both
repositories. Security severity above is `rule.security_severity_level`, not
SARIF's generic warning/error level. Zero open secret alerts supports the bounded
`no_leaked_credentials` answer for detected supported-pattern findings; it is not
proof of a clean history for all secret types, deleted history or external systems.
Non-provider patterns and validity checks are disabled in the observed settings.
No secret values or private report contents were collected or published.

#### CodeQL disposition follow-up — 2026-11-22

Historical triage snapshot: the later CLI closure below supersedes its pending
CLI fix status and four-open-alert count.

The [follow-up API receipts](evidence/best-practices-2026-11-22.json) retain the
initial inventory above and add live open inventories plus the state, reason,
written comment and dismissal timestamp of every previously open CodeQL alert.
The responsible maintainer triaged these findings; this documentation change
only reads those dispositions and does not dismiss alerts.

| Repository | Current open CodeQL (critical / high / medium / low) | Disposition and remaining work |
| --- | --- | --- |
| rust-mirror | 0 / 4 / 0 / 0 | #6, #7 and #12–17 dismissed with written reasons; #8–11 pending code fixes and merge. |
| rust-mirror-gui | 0 / 0 / 0 / 0 | #6–18 dismissed with written reasons; no remaining open CodeQL finding in this snapshot. |

- CLI [#6](https://github.com/rustcommons/rust-mirror/security/code-scanning/6)
  and [#7](https://github.com/rustcommons/rust-mirror/security/code-scanning/7):
  false positives; SHA-1 computes certificate thumbprints required by macOS
  `security` / Windows `certutil` for disposable test CA lookup/removal, not data
  protection.
- CLI [#12–14](https://github.com/rustcommons/rust-mirror/security/code-scanning/12):
  `#[cfg(test)]` RFC 7617 encoding vectors and dummy values. [#15–17](https://github.com/rustcommons/rust-mirror/security/code-scanning/15):
  local-server integration-test dummy credentials. All are dismissed as used in tests.
- GUI [#6](https://github.com/rustcommons/rust-mirror-gui/security/code-scanning/6):
  test-only fake backend; [#7](https://github.com/rustcommons/rust-mirror-gui/security/code-scanning/7):
  an empty password for an offline release-list operation, not a secret.
  [#8–17](https://github.com/rustcommons/rust-mirror-gui/security/code-scanning/8):
  test-only dummy proxy/publish passwords used to verify argv exclusion/stdin
  handling; [#18](https://github.com/rustcommons/rust-mirror-gui/security/code-scanning/18):
  integration-test dummy credentials. The API receipts contain every individual
  alert URL and written reason rather than treating a range link as all evidence.
- CLI [#10](https://github.com/rustcommons/rust-mirror/security/code-scanning/10)
  and [#11](https://github.com/rustcommons/rust-mirror/security/code-scanning/11)
  remain open: path containment in the `prove_offline.py` test upload server.
  [#8](https://github.com/rustcommons/rust-mirror/security/code-scanning/8) and
  [#9](https://github.com/rustcommons/rust-mirror/security/code-scanning/9) remain
  open: enforce TLS 1.2 minimum on test TLS servers. The fixes are pending;
  the read-only open-PR query returned no PR to pin at observation. Record the
  actual reviewed fix PR/merged revision and verification before closing the gap.

At that snapshot, `static_analysis_fixed` was **pending until those CLI fixes
merged**. GUI CodeQL triage was complete in the observed inventory. The CLI
closure below now records the merge and live fixed states; the GUI proposed
answer is left unchanged by this CLI-only verification.

The remaining Scorecard alerts are **posture checks, excluded from
`static_analysis_fixed`**: CLI #27/#30/#31 (Branch-Protection, Code-Review,
CII-Best-Practices), GUI #19/#22/#24/#25/#26 (Branch-Protection, Vulnerabilities,
Code-Review, Maintained, CII-Best-Practices). They remain visible in the separate
inventory; they are not source static-analysis findings and this criterion does
not certify their resolution or the repositories' overall security posture.

#### CLI CodeQL fix closure — 2026-11-22

[PR #82](https://github.com/rustcommons/rust-mirror/pull/82) merged at
[`8d3a15c55e10c69f134d04c5cfa5800ca460922c`](https://github.com/rustcommons/rust-mirror/commit/8d3a15c55e10c69f134d04c5cfa5800ca460922c)
on 2026-11-22T22:24:34Z. It adds path containment to the
[`prove_offline.py` upload fixture](https://github.com/rustcommons/rust-mirror/blob/8d3a15c55e10c69f134d04c5cfa5800ca460922c/scripts/prove_offline.py),
a TLS 1.2 minimum to the
[test TLS servers](https://github.com/rustcommons/rust-mirror/blob/8d3a15c55e10c69f134d04c5cfa5800ca460922c/scripts/prove_rustup_lifecycle.py),
and regression tests. These are code fixes, not alert dismissals.

The [read-only closure receipts](evidence/codeql-fixes-2026-11-22.json) confirm
alerts [#8](https://github.com/rustcommons/rust-mirror/security/code-scanning/8),
[#9](https://github.com/rustcommons/rust-mirror/security/code-scanning/9),
[#10](https://github.com/rustcommons/rust-mirror/security/code-scanning/10) and
[#11](https://github.com/rustcommons/rust-mirror/security/code-scanning/11) each have
`state: fixed`, `fixed_at: 2026-11-22T22:25:16Z`, and no dismissal timestamp.
Main's CodeQL Python analysis **2225647618** is at that exact merge commit and
time, with no analysis error or warning. Its two raw results are not an open-alert
count: earlier written dismissals remain part of the analysis history.

The new paginated open-alert query returns **zero open CodeQL alerts** for the CLI.
Only three Scorecard posture checks remain open; these stay excluded from
`static_analysis_fixed`. Together with the earlier written dispositions, the
confirmed code-fix closure supports **Met for rust-mirror** for this criterion.
This does not certify the absence of all vulnerabilities, update an immutable
release, or close the separate owner-attestation/private-response gaps. The GUI
answer is not changed by this CLI-only follow-up.

### Dynamic analysis and failure history

[CLI PR fuzz run 45033592562](https://github.com/rustcommons/rust-mirror/actions/runs/45033592562)
and [GUI PR fuzz run 45067906584](https://github.com/rustcommons/rust-mirror-gui/actions/runs/45067906584)
passed; inspected logs report no reportable crashes in the exercised targets.
[CLI fuzz scope](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/docs/FUZZING.md) covers seven bounded parser
adapters; [GUI scope](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/FUZZING.md) covers event lines,
streams, settings and CA input. Both PR workflows use AddressSanitizer and a
300-second shared engine budget. No confirmed dynamic-analysis exploit or crash
fix was identified in the inspected evidence; this is finite analysis, not proof
that all code is safe. The CLI's [dated local record](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/docs/evals/2026-11-18-parser-fuzzing.md)
also reports seven finite ASan runs without findings.

API history contains 20 CLI PR runs (8 success, 4 failure, 7 cancelled, 1 skipped)
and 13 GUI PR runs (9 success, 1 failure, 3 cancelled). All five failed-run logs
were inspected: CLI 44236153835 lacked `/src/build.sh`; 44898438103, 44902370077
and 44904451990 refused an outdated fuzz lock under `--locked`; GUI 44238348594
used a nightly below dependency MSRV. These are setup failures, not hidden crashes;
subsequent named successes use the corrected builds. The
[CLI](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/.github/workflows/cflite_batch.yml) and
[GUI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/cflite_batch.yml) weekly workflows
are configured for 1800 seconds, but their run histories are **empty** at observation.
Do not claim completed weekly fuzzing. No ClusterFuzzLite tool alerts are open in
the code-scanning inventory. Assertion-enabled coverage of all unsafe code remains
unestablished; do not derive it from a green fuzz job.

### Vulnerability age and public response evidence

| Advisory | Report/known date evidence | Fix and release evidence | Remaining boundary |
| --- | --- | --- | --- |
| [GHSA-46c8-w6pp-97pw](https://github.com/rustcommons/rust-mirror/security/advisories/GHSA-46c8-w6pp-97pw) | Repository advisory created 2026-11-15T23:10:41Z; published 2026-11-16T05:35:02Z. Private report receipt date is not established by creation time. | [Fix commit 826cc1f](https://github.com/rustcommons/rust-mirror/commit/826cc1f22e5267d0c88dfc721ef7cfdbf67f8ebd), 2026-11-15T23:20:09Z; patched crate 0.5.3 published 2026-11-16, first patched CLI downloads 0.5.4 on 2026-11-16. GUI [0.5.1](https://github.com/rustcommons/rust-mirror-gui/releases/tag/v0.5.1), 2026-11-16T12:53:08Z, adopted engine 0.5.4. Current released graphs retain the fixes. | Affected CLI <=0.5.2; 0.5.3 remains crate-only. Published advisory API state takes precedence over its stale body sentence saying draft. No private acknowledgment timing follows from these dates. |
| [RUSTSEC-2026-0592](https://github.com/RustSec/advisory-db/blob/8b75c83c3c9142dd18e93d75b8d895a13d285861/crates/url/RUSTSEC-2026-0592.md) | Source advisory date 2026-11-20, affecting `Url::origin` / `url::quirks::origin` <=2.5.8. | GUI [9086496](https://github.com/rustcommons/rust-mirror-gui/commit/9086496f879cfa1f9267d0caa99a780825702dda), 2026-11-22T14:04:21Z; CLI [9e69567](https://github.com/rustcommons/rust-mirror/commit/9e69567d9fb67787438adcb23977c10d48d32983), 2026-11-22T14:34:29Z, bump `url` to 2.5.9 (two calendar days after the advisory date; no advisory time-of-day proves <=48 hours). GUI shipped that fix in [0.5.3](https://github.com/rustcommons/rust-mirror-gui/releases/tag/v0.5.3) at 2026-11-22T15:50:19Z and retains it in 0.5.4. | CLI 0.6.1 retains `url` 2.5.7; its [source/ureq exposure assessment](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/docs/evals/2026-11-22-publication-0.6.1.md) found no calls to the affected origin functions. Main's lock fix is not a published CLI update; non-reachability, not a released lock fix, bounds that released graph. |

The published repository advisory inventory contains that one CLI GHSA and zero
GUI advisories. Both open Dependabot inventories are empty, including alerts
older than 60 days. [CLI security 45035631493](https://github.com/rustcommons/rust-mirror/actions/runs/45035631493)
passes cargo-deny at the reviewed maintenance source; the released GUI pipeline
also audits its crate before publication. These observations support the bounded
60-day answer for the known inventory; they are not a complete vulnerability
proof or a disposition of the open CodeQL/Scorecard findings above. Unknown
exposure remains subject to review; do not mark critical-fix disposition complete.

For the public response window, 2026-09-22 through this observation on 2026-11-22,
all-state paginated Issues contain one CLI issue and zero GUI issues. CLI
[issue #67](https://github.com/rustcommons/rust-mirror/issues/67) was a maintainer-filed
test-fixture bug, created 2026-11-16T12:33:48Z, first public follow-up
[12:41:58Z](https://github.com/rustcommons/rust-mirror/issues/67#issuecomment-6916716086),
closed 12:48:11Z. This is one observed response within 8 minutes 10 seconds,
not an external-report response distribution. Other GitHub Issues records are PRs
and excluded. It supplements the preserved Nov 16 audit rather than replacing it.
For private vulnerability reports (2026-05-22 through observation), no sanitized
receipt/response aggregate or zero-applicable-report confirmation is available.
Neither an empty public tracker nor the advisory endpoint establishes that fact.
`vulnerability_report_response` remains **Unmet** pending a responsible maintainer's
channel/window check and sanitized dates/counts (or confirmed zero reports, which
the criterion permits as N/A). Do not publish private report contents.

## Basics

| Criterion ID | Weight | CLI | GUI | Justification URL, limitation and proposed fix |
| --- | --- | --- | --- | --- |
| `description_good` | MUST | Met | Met | Purpose and scope are explicit: [CLI README](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/README.md), [GUI README](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/README.md). |
| `interact` | MUST | Met | Met | [Default CONTRIBUTING](../CONTRIBUTING.md) explains obtaining products/source, public Issues for bugs/features, private security reporting and PR contributions. Default merged; [override audit](RESPONSE-HISTORY-AUDIT.md#default-guide-applicability) found no local override in either repository. |
| `contribution` | MUST | Met | Met | [Default PR process](../CONTRIBUTING.md#propose-and-validate-changes) documents topic branches, protected-main PRs, validation and maintainer merge/release authority. Default merged; per-repository AGENTS remains primary for commands/scope. |
| `contribution_requirements` | SHOULD | Met | Met | [Default requirements](../CONTRIBUTING.md#propose-and-validate-changes) state test, formatting, documentation/traceability, security and dependency rules; repository-specific AGENTS supplies commands. Default is now on main; verify inherited visibility at registration. |
| `floss_license` | MUST | Met | Met | Apache-2.0 declared with root license: [CLI LICENSE](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/LICENSE), [GUI LICENSE](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/LICENSE). GUI bundled-font terms are separately included; this answer does not relabel all dependencies Apache-2.0. |
| `floss_license_osi` | SUGGESTED | Met | Met | Apache-2.0 declared with root license: [CLI LICENSE](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/LICENSE), [GUI LICENSE](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/LICENSE). GUI bundled-font terms are separately included; this answer does not relabel all dependencies Apache-2.0. |
| `license_location` | MUST | Met | Met | Apache-2.0 declared with root license: [CLI LICENSE](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/LICENSE), [GUI LICENSE](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/LICENSE). GUI bundled-font terms are separately included; this answer does not relabel all dependencies Apache-2.0. |
| `documentation_basics` | MUST | Met | Met | [CLI user guide](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/docs/USER-GUIDE.md), [GUI tutorial](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/TUTORIAL.md) and installation/runtime limits document use. |
| `documentation_interface` | MUST | Met | Met | [CLI command/input/output reference](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/docs/CLI-REFERENCE.md) and [GUI tutorial](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/TUTORIAL.md) describe supported user interfaces; the internal worker contract is not an arbitrary remote API. |
| `sites_https` | MUST | Met | Met | Official repository/download/docs URLs use HTTPS in [CLI README](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/README.md) and [GUI README](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/README.md). This does not approve arbitrary customer HTTP hosts. |
| `discussion` | MUST | Met | Met | Public GitHub issue and PR archives provide URL-addressable discussion/reporting: [CLI issues](https://github.com/rustcommons/rust-mirror/issues), [GUI issues](https://github.com/rustcommons/rust-mirror-gui/issues). Issues enabled in [provider observations](evidence/security-assurance-2026-11-16.json). |
| `english` | SHOULD | Met | Met | English guides and source-facing instructions: [CLI README](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/README.md), [GUI README](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/README.md). English communication is used; no multilingual commitment is implied. |
| `maintained` | MUST | Met | Met | Public Git repositories with interim PRs and dated commits: [CLI history](https://github.com/rustcommons/rust-mirror/commits/3c11d914bce9a06cb92ef7f39179e3a42f98cab0), [GUI history](https://github.com/rustcommons/rust-mirror-gui/commits/06927ece4f1fadc59f2ef015d7c21bf950da0630); active release records [CLI](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/docs/evals/2026-11-22-publication-0.6.1.md) / [GUI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md). No long-term staffing guarantee. |

## Change Control

| Criterion ID | Weight | CLI | GUI | Justification URL, limitation and proposed fix |
| --- | --- | --- | --- | --- |
| `repo_public` | MUST | Met | Met | Public Git repositories with interim PRs and dated commits: [CLI history](https://github.com/rustcommons/rust-mirror/commits/3c11d914bce9a06cb92ef7f39179e3a42f98cab0), [GUI history](https://github.com/rustcommons/rust-mirror-gui/commits/06927ece4f1fadc59f2ef015d7c21bf950da0630); active release records [CLI](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/docs/evals/2026-11-22-publication-0.6.1.md) / [GUI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md). No long-term staffing guarantee. |
| `repo_track` | MUST | Met | Met | Public Git repositories with interim PRs and dated commits: [CLI history](https://github.com/rustcommons/rust-mirror/commits/3c11d914bce9a06cb92ef7f39179e3a42f98cab0), [GUI history](https://github.com/rustcommons/rust-mirror-gui/commits/06927ece4f1fadc59f2ef015d7c21bf950da0630); active release records [CLI](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/docs/evals/2026-11-22-publication-0.6.1.md) / [GUI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md). No long-term staffing guarantee. |
| `repo_interim` | MUST | Met | Met | Public Git repositories with interim PRs and dated commits: [CLI history](https://github.com/rustcommons/rust-mirror/commits/3c11d914bce9a06cb92ef7f39179e3a42f98cab0), [GUI history](https://github.com/rustcommons/rust-mirror-gui/commits/06927ece4f1fadc59f2ef015d7c21bf950da0630); active release records [CLI](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/docs/evals/2026-11-22-publication-0.6.1.md) / [GUI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md). No long-term staffing guarantee. |
| `repo_distributed` | SUGGESTED | Met | Met | Public Git repositories with interim PRs and dated commits: [CLI history](https://github.com/rustcommons/rust-mirror/commits/3c11d914bce9a06cb92ef7f39179e3a42f98cab0), [GUI history](https://github.com/rustcommons/rust-mirror-gui/commits/06927ece4f1fadc59f2ef015d7c21bf950da0630); active release records [CLI](https://github.com/rustcommons/rust-mirror/blob/b14ca618ee6d043eac979a7d50b3f9fa6d4701ab/docs/evals/2026-11-22-publication-0.6.1.md) / [GUI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md). No long-term staffing guarantee. |
| `version_unique` | MUST | Met | Met | Versioned tags/manifests and user-facing notes: [CLI 0.6.1](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/docs/releases/v0.6.1.md), [GUI 0.5.4](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md). Immutable package/tag boundaries remain explicit. |
| `version_semver` | SUGGESTED | Met | Met | Versioned tags/manifests and user-facing notes: [CLI 0.6.1](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/docs/releases/v0.6.1.md), [GUI 0.5.4](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md). Immutable package/tag boundaries remain explicit. |
| `version_tags` | SUGGESTED | Met | Met | Versioned tags/manifests and user-facing notes: [CLI 0.6.1](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/docs/releases/v0.6.1.md), [GUI 0.5.4](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md). Immutable package/tag boundaries remain explicit. |
| `release_notes` | MUST | Met | Met | Versioned tags/manifests and user-facing notes: [CLI 0.6.1](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/docs/releases/v0.6.1.md), [GUI 0.5.4](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.4.md). Immutable package/tag boundaries remain explicit. |
| `release_notes_vulns` | MUST | Met | Met | [CLI historical dependency-security notes](https://github.com/rustcommons/rust-mirror/blob/e74f91b3f39f7ff78675f184b75c5602d681d377/docs/releases/v0.5.3.md) preserve the patched boundary; [GUI 0.5.3 notes](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/docs/releases/v0.5.3.md) identify RUSTSEC-2026-0592 and URL upgrade. Later immutable releases retain their own notes. |

## Reporting

| Criterion ID | Weight | CLI | GUI | Justification URL, limitation and proposed fix |
| --- | --- | --- | --- | --- |
| `report_process` | MUST | Met | Met | Public GitHub issue and PR archives provide URL-addressable discussion/reporting: [CLI issues](https://github.com/rustcommons/rust-mirror/issues), [GUI issues](https://github.com/rustcommons/rust-mirror-gui/issues). Issues enabled in [provider observations](evidence/security-assurance-2026-11-16.json). |
| `report_tracker` | SHOULD | Met | Met | Public GitHub issue and PR archives provide URL-addressable discussion/reporting: [CLI issues](https://github.com/rustcommons/rust-mirror/issues), [GUI issues](https://github.com/rustcommons/rust-mirror-gui/issues). Issues enabled in [provider observations](evidence/security-assurance-2026-11-16.json). |
| `report_responses` | MUST | Met | Met | [Current public issue audit](#vulnerability-age-and-public-response-evidence): one maintainer-filed CLI fixture issue, first follow-up in 8m10s; GUI zero issues. [Nov 16 empty-window snapshot](RESPONSE-HISTORY-AUDIT.md#public-issue-results) remains historical; no off-platform/private inference. |
| `enhancement_responses` | SHOULD | Met | Met | [Current public issue audit](#vulnerability-age-and-public-response-evidence): the sole CLI issue is a fixture bug; no enhancement issue in either observed window. PRs excluded; no response-rate claim for an empty enhancement denominator. |
| `report_archive` | MUST | Met | Met | Public GitHub issue and PR archives provide URL-addressable discussion/reporting: [CLI issues](https://github.com/rustcommons/rust-mirror/issues), [GUI issues](https://github.com/rustcommons/rust-mirror-gui/issues). Issues enabled in [provider observations](evidence/security-assurance-2026-11-16.json). |
| `vulnerability_report_process` | MUST | Met | Met | [Inherited security policy](../SECURITY.md) documents private GitHub reporting; [API observations](evidence/security-assurance-2026-11-16.json) confirm enabled reporting in both repositories. No private report contents are needed as evidence. |
| `vulnerability_report_private` | MUST | Met | Met | [Inherited security policy](../SECURITY.md) documents private GitHub reporting; [API observations](evidence/security-assurance-2026-11-16.json) confirm enabled reporting in both repositories. No private report contents are needed as evidence. |
| `vulnerability_report_response` | MUST | Unmet | Unmet | [Current private-window gap](#vulnerability-age-and-public-response-evidence) and [historical audit](RESPONSE-HISTORY-AUDIT.md#private-vulnerability-response-window): no receipt/first-response aggregate or confirmed zero-report window. Supply sanitized channel/window counts and <=14-day initial-response evidence; use permitted N/A only after confirming zero applicable reports. |

## Quality

| Criterion ID | Weight | CLI | GUI | Justification URL, limitation and proposed fix |
| --- | --- | --- | --- | --- |
| `build` | MUST | Met | Met | [CLI Cargo manifest](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/Cargo.toml), [GUI Cargo manifest](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/Cargo.toml) and checked-in build workflows provide Cargo/Rust builds. Linux builds use FLOSS tools; this does not claim Windows MSVC/SDK tooling is FLOSS or every platform is supported. |
| `build_common_tools` | SUGGESTED | Met | Met | [CLI Cargo manifest](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/Cargo.toml), [GUI Cargo manifest](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/Cargo.toml) and checked-in build workflows provide Cargo/Rust builds. Linux builds use FLOSS tools; this does not claim Windows MSVC/SDK tooling is FLOSS or every platform is supported. |
| `build_floss_tools` | SHOULD | Met | Met | [CLI Cargo manifest](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/Cargo.toml), [GUI Cargo manifest](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/Cargo.toml) and checked-in build workflows provide Cargo/Rust builds. Linux builds use FLOSS tools; this does not claim Windows MSVC/SDK tooling is FLOSS or every platform is supported. |
| `test` | MUST | Met | Met | [CLI CI](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/.github/workflows/ci.yml), [GUI CI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/ci.yml) invoke Cargo tests; test/fixture source is public under repository licensing. Current release-pipeline runs appear in [source boundaries](#source-boundaries-and-dated-history); [Nov 16 runs](evidence/security-assurance-2026-11-16.json) remain historical. |
| `test_invocation` | SHOULD | Met | Met | [CLI CI](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/.github/workflows/ci.yml), [GUI CI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/ci.yml) invoke Cargo tests; test/fixture source is public under repository licensing. Current release-pipeline runs appear in [source boundaries](#source-boundaries-and-dated-history); [Nov 16 runs](evidence/security-assurance-2026-11-16.json) remain historical. |
| `test_most` | SUGGESTED | Unmet | Unmet | [CLI functional corpus](https://github.com/rustcommons/rust-mirror/blob/b254027cd8a31ebadd92f712671ed0d76c28561a/docs/evals/2026-11-13-crates-mvp.md) / [GUI test scope](https://github.com/rustcommons/rust-mirror-gui/blob/af94a31894d2e052c4044ed24a0506d854e14b2e/docs/evals/2026-11-15-v0.5.0-validation.md) do not establish measured branch/input coverage of most functionality. Fix: collect coverage and identify untested branches/platform input classes; do not infer coverage from test counts. |
| `test_continuous_integration` | SUGGESTED | Met | Met | [CLI CI](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/.github/workflows/ci.yml), [GUI CI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/ci.yml) invoke Cargo tests; test/fixture source is public under repository licensing. Current release-pipeline runs appear in [source boundaries](#source-boundaries-and-dated-history); [Nov 16 runs](evidence/security-assurance-2026-11-16.json) remain historical. |
| `test_policy` | MUST | Met | Met | [Default test policy](../CONTRIBUTING.md#propose-and-validate-changes): “Major new functionality must include automated tests.” The default is merged; documentation-only validation and regression-test scope remain explicit. |
| `tests_are_added` | MUST | Met | Met | [Historical crate feature tests](https://github.com/rustcommons/rust-mirror/blob/b254027cd8a31ebadd92f712671ed0d76c28561a/docs/evals/2026-11-13-crates-mvp.md) and [Historical font/layout tests](https://github.com/rustcommons/rust-mirror-gui/blob/af94a31894d2e052c4044ed24a0506d854e14b2e/docs/evals/2026-11-15-v0.5.0-validation.md) document tests accompanying major changes, with source locations and outcomes. This is bounded change evidence, not a coverage claim. |
| `tests_documented_added` | SUGGESTED | Met | Met | The new-functionality test policy is explicitly in [contribution/change-proposal instructions](../CONTRIBUTING.md#propose-and-validate-changes), with test command/results required in PRs. The default is merged; this is not evidence that all future features have already been tested. |
| `warnings` | MUST | Met | Met | [CLI security/core checks](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/.github/workflows/security.yml) / [GUI CI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/ci.yml) use Clippy with warnings denied; historical validation [CLI](https://github.com/rustcommons/rust-mirror/blob/b254027cd8a31ebadd92f712671ed0d76c28561a/docs/evals/2026-11-15-release-0.5.3.md) / [GUI](https://github.com/rustcommons/rust-mirror-gui/blob/af94a31894d2e052c4044ed24a0506d854e14b2e/docs/evals/2026-11-15-v0.5.0-validation.md) records passed checks. Cargo dependency informational/duplicate warnings and approved exceptions are separate from compiler warnings. |
| `warnings_fixed` | MUST | Met | Met | [CLI security/core checks](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/.github/workflows/security.yml) / [GUI CI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/ci.yml) use Clippy with warnings denied; historical validation [CLI](https://github.com/rustcommons/rust-mirror/blob/b254027cd8a31ebadd92f712671ed0d76c28561a/docs/evals/2026-11-15-release-0.5.3.md) / [GUI](https://github.com/rustcommons/rust-mirror-gui/blob/af94a31894d2e052c4044ed24a0506d854e14b2e/docs/evals/2026-11-15-v0.5.0-validation.md) records passed checks. Cargo dependency informational/duplicate warnings and approved exceptions are separate from compiler warnings. |
| `warnings_strict` | SUGGESTED | Met | Met | [CLI security/core checks](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/.github/workflows/security.yml) / [GUI CI](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/ci.yml) use Clippy with warnings denied; historical validation [CLI](https://github.com/rustcommons/rust-mirror/blob/b254027cd8a31ebadd92f712671ed0d76c28561a/docs/evals/2026-11-15-release-0.5.3.md) / [GUI](https://github.com/rustcommons/rust-mirror-gui/blob/af94a31894d2e052c4044ed24a0506d854e14b2e/docs/evals/2026-11-15-v0.5.0-validation.md) records passed checks. Cargo dependency informational/duplicate warnings and approved exceptions are separate from compiler warnings. |

## Security

| Criterion ID | Weight | CLI | GUI | Justification URL, limitation and proposed fix |
| --- | --- | --- | --- | --- |
| `know_secure_design` | MUST | Met | Met | Owner attestation published 2026-11-22: [secure design statement](OWNER-ATTESTATIONS.md#secure-design) by Joey Huckabee, owner and lead maintainer, covering all ten required principles with project examples. Use its URL as the justification. |
| `know_common_errors` | MUST | Met | Met | Owner attestation published 2026-11-22: [common errors statement](OWNER-ATTESTATIONS.md#common-errors) by Joey Huckabee, listing nine error categories with at least one applied mitigation each. Use its URL as the justification. |
| `crypto_published` | MUST | Met | Met | [CLI SHA-256 implementation](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/src/lib.rs), [network/TLS delegation](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/src/network.rs) and [GUI engine/lock](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/Cargo.lock) use established library cryptography rather than custom algorithms. The GUI release has its own locked dependency/security boundary. |
| `crypto_call` | SHOULD | Met | Met | [CLI SHA-256 implementation](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/src/lib.rs), [network/TLS delegation](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/src/network.rs) and [GUI engine/lock](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/Cargo.lock) use established library cryptography rather than custom algorithms. The GUI release has its own locked dependency/security boundary. |
| `crypto_floss` | MUST | Met | Met | [CLI SHA-256 implementation](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/src/lib.rs), [network/TLS delegation](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/src/network.rs) and [GUI engine/lock](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/Cargo.lock) use established library cryptography rather than custom algorithms. The GUI release has its own locked dependency/security boundary. |
| `crypto_keylength` | MUST | Met | Met | [Effective provider, suites, protocol versions and minima](#cryptographic-configuration): released engine ring/rustls defaults exclude undersized keys and obsolete suites; GUI 0.5.4 locks that engine/provider. No per-site certificate or independent crypto certification claim. |
| `crypto_working` | MUST | Met | Met | [Released configuration and upstream defaults](#cryptographic-configuration) use TLS 1.2/1.3 AEAD suites and library SHA-256; no custom crypto or broken algorithm in the audited security defaults. Hash-only metadata integrity is not independent upstream authentication. |
| `crypto_weaknesses` | SHOULD | Met | Met | [Provider configuration](#cryptographic-configuration) excludes known-broken default suites/versions; this bounded answer does not certify arbitrary library-consumer feature unification or private TLS servers. |
| `crypto_pfs` | SHOULD | Met | Met | [Default suites/groups](#cryptographic-configuration) use ephemeral key exchange (TLS 1.2 ECDHE and TLS 1.3); no static RSA key-exchange suite is enabled. |
| `crypto_password_storage` | MUST | N/A | N/A | [Credential contract](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/docs/NETWORK.md) and [GUI settings](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/src/settings.rs) do not implement persistent password-verifier storage; credentials are transient client inputs. This does not exempt process memory, worker environment, logs or external Nexus password storage from review. |
| `crypto_random` | MUST | Met | Met | [Provider-to-SystemRandom-to-getrandom source chain](#cryptographic-configuration), including exact published ring source comparison, delegates native TLS keys/nonces to OS CSPRNG. No project PRNG supplies TLS entropy. |
| `delivery_mitm` | MUST | Met | Met | [Current phase 2 release evidence](#source-boundaries-and-dated-history) includes HTTPS, SHA256SUMS, attached provenance bundles and SBOM bindings with strict reusable-signer/source-digest verification. No OS code-signing, OpenPGP or independent certification claim. |
| `delivery_unsigned` | MUST | Met | Met | [Current phase 2 release evidence](#source-boundaries-and-dated-history) includes HTTPS, SHA256SUMS, attached provenance bundles and SBOM bindings with strict reusable-signer/source-digest verification. No OS code-signing, OpenPGP or independent certification claim. |
| `vulnerabilities_fixed_60_days` | MUST | Met | Met | [Advisory chronology, exposure assessment and alert age inventory](#vulnerability-age-and-public-response-evidence): published GHSA patched; URL advisory handled within two calendar days, GUI shipped fix and released CLI assessed unreachable; 0 open Dependabot alerts/0 older than 60 days each. Bounded known inventory, not all-finding or all-runtime certification. |
| `vulnerabilities_critical_fixed` | SHOULD | Unmet | Unmet | [Current dispositions](#codeql-disposition-follow-up--2026-11-22) close the former critical CodeQL alerts with written reasons; remaining CLI findings are high, not critical. A complete timing assessment for all confirmed critical vulnerabilities is still not established by this alert snapshot. Retain Unmet pending that separate assessment. |
| `no_leaked_credentials` | MUST | Met | Met | [Dated paginated API inventory](#alerts-and-static-analysis-disposition): secret scanning and push protection enabled; 0 open secret alerts each. Bounded to detected provider patterns/current API-visible alerts, not a universal absence-of-secrets or rotation-history attestation. |

## Analysis

| Criterion ID | Weight | CLI | GUI | Justification URL, limitation and proposed fix |
| --- | --- | --- | --- | --- |
| `static_analysis` | MUST | Met | Met | [CLI zizmor/cargo-deny](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/.github/workflows/security.yml) / [GUI Clippy/cargo-deny](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/ci.yml) plus [Current CodeQL settings and findings](#alerts-and-static-analysis-disposition) show regular source/workflow/security analysis. Detection is bounded by tool/rule/graph versions. |
| `static_analysis_common_vulnerabilities` | SUGGESTED | Met | Met | [CLI zizmor/cargo-deny](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/.github/workflows/security.yml) / [GUI Clippy/cargo-deny](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/ci.yml) plus [Current CodeQL settings and findings](#alerts-and-static-analysis-disposition) show regular source/workflow/security analysis. Detection is bounded by tool/rule/graph versions. |
| `static_analysis_fixed` | MUST | Met | Unmet | [CLI closure](#cli-codeql-fix-closure--2026-11-22): PR #82 merged at 8d3a15c; main CodeQL confirms #8–11 fixed at 2026-11-22T22:25:16Z, with zero open CLI CodeQL alerts. Earlier written dismissals are preserved; Scorecard posture checks are excluded. GUI retains its earlier proposed-answer state pending a separate final registration review; this follow-up verifies CLI only. |
| `static_analysis_often` | SUGGESTED | Met | Met | [CLI zizmor/cargo-deny](https://github.com/rustcommons/rust-mirror/blob/3c11d914bce9a06cb92ef7f39179e3a42f98cab0/.github/workflows/security.yml) / [GUI Clippy/cargo-deny](https://github.com/rustcommons/rust-mirror-gui/blob/06927ece4f1fadc59f2ef015d7c21bf950da0630/.github/workflows/ci.yml) plus [Current CodeQL settings and findings](#alerts-and-static-analysis-disposition) show regular source/workflow/security analysis. Detection is bounded by tool/rule/graph versions. |
| `dynamic_analysis` | SUGGESTED | Met | Met | [ClusterFuzzLite AddressSanitizer PR execution](#dynamic-analysis-and-failure-history), 300-second shared budgets and bounded documented targets. Weekly configuration is present, with zero completed weekly runs at observation. |
| `dynamic_analysis_unsafe` | SUGGESTED | Unmet | Unmet | [Current ASan scope](#dynamic-analysis-and-failure-history) does not establish analysis of all unsafe/native/dependency code. Map unsafe paths to exercised targets and instrument any uncovered relevant paths before asserting coverage. |
| `dynamic_analysis_enable_assertions` | SUGGESTED | Unmet | Unmet | [Current fuzz build/run evidence](#dynamic-analysis-and-failure-history) establishes ASan but not all assertion settings for every analyzed component. Record effective build flags and assertion coverage before marking Met. |
| `dynamic_analysis_fixed` | MUST | Met | Met | [Named ASan PR runs, crash outcome and failed-run audit](#dynamic-analysis-and-failure-history): no confirmed exploitable dynamic-analysis findings or reportable crashes identified in inspected evidence; earlier failures are build setup/lock/MSRV. No crash fix was needed for those findings; weekly jobs configured but not yet run. Finite evidence only. |

## Owner attestations still required

**Update 2026-11-22:** both statements are published in [OWNER-ATTESTATIONS.md](OWNER-ATTESTATIONS.md). The templates below are kept as the original guidance.

`know_secure_design` and `know_common_errors` remain **Unmet — owner-attestation
pending**. Code, a job title and green CI do not supply this attestation. The
[official criterion details](https://www.bestpractices.dev/en/criteria/0?details=true&rationale=true)
([pinned definitions](https://github.com/ossf/best-practices-badge/blob/31325acd7963e0c9203da0ff798802a766237517/config/locales/en.yml))
require a primary developer who has the relevant knowledge. If the owner is not
a primary developer of a listed project, obtain the statement from a person who
is; do not attest to someone else's knowledge by assumption.

At review the owner needs to provide **a real person's name or public handle,
which project(s) they cover, why they are a primary developer, a UTC date, and
the two truthful affirmations below**. Describe relevant experience or training
as the basis; a course or certificate is not required by these criteria. Optional
supporting URLs can identify role or experience. Publish a reviewed statement as
the justification URL before marking these rows Met; do not submit this unfilled
proposal as an already-made attestation.

**Secure-design statement to fill and affirm:**

> I, [name/handle], am a primary developer of [rust-mirror, rust-mirror-gui, or
> both], because [role and familiarity with the code/change/release process]. As
> of [UTC date], I personally know how to design secure software and understand
> and can apply all ten principles listed below to the named projects. My basis
> is [truthful relevant experience or training; optional supporting URL].

The affirmation must cover every principle: economy of mechanism; fail-safe
defaults; complete mediation; open design; separation of privilege; least
privilege; least common mechanism; psychological acceptability; limited attack
surface; and input validation using allowlists. The statement concerns the
person's knowledge, not a claim that every project control is complete or every
attack is prevented.

**Common-error statement to fill and affirm:**

> I, [same or another identified primary developer, with project/role and UTC
> date], personally know the following project-relevant error categories and at
> least one mitigation for each. I understand the error/mitigation pairs in the
> table below [identify any additions or corrections needed for the actual
> project scope]. My basis is [truthful experience or training]. I have reviewed
> the assurance report's remaining limits and do not claim these examples
> eliminate all vulnerabilities.

| Relevant error category | At least one mitigation the developer must understand |
| --- | --- |
| Path traversal, unsafe file/link handling | Validate allowed paths, reject unexpected links/entries and verify closure; understand remaining hostile-filesystem/race limits. [Engine/publisher evidence](SECURITY-ASSURANCE.md#5-integrity-chain-end-to-end). |
| Command/argument injection | Separate executable and argument arrays; avoid concatenating untrusted values into shell commands; validate accepted inputs. [Worker boundary](SECURITY-ASSURANCE.md#3-architecture-and-trust-boundaries). |
| Missing authentication/authorization or SSRF | Restrict official upstream origins and explicit destinations, scope credentials, and validate each permitted operation; site authorization remains separate. [Threat model](SECURITY-ASSURANCE.md#4-threat-model). |
| MITM/certificate-verification mistakes | Keep TLS identity/chain verification on and manage approved CA/proxy trust; no insecure validation bypass. [Network evidence](SECURITY-ASSURANCE.md#7-network-behavior-and-offline-evidence). |
| Unchecked integrity, stale input and unsafe overwrite | Verify payload digests, freeze approved metadata, rehash resume state and refuse existing publication paths; understand that readback is not a global transaction. [Integrity chain](SECURITY-ASSURANCE.md#5-integrity-chain-end-to-end). |
| Credential disclosure | Avoid secrets in argv/saved settings/logs; use private stdin or explicitly scoped process credentials and redaction; account for environment/memory exposure. [Credential handling](SECURITY-ASSURANCE.md#6-credential-and-secret-handling). |
| Resource exhaustion and stalled work | Bound metadata, byte/file/event counts and retries; use cancellation/deadlines/stall warnings while recognizing resolver and CPU limits. [Residual risks](SECURITY-ASSURANCE.md#13-residual-risks-and-limitations). |
| Memory/buffer/FFI mistakes | Use checked/owned Rust data and validate bounds; assess unsafe/dependency/native code rather than assuming all linked code is memory-safe. [Dependency and analysis scope](SECURITY-ASSURANCE.md#8-software-supply-chain). |

These are suggested knowledge statements, not proof of the controls' execution
or a request to invent training. The separate private response-history evidence
needed for `vulnerability_report_response` is described in the
[audit](RESPONSE-HISTORY-AUDIT.md#private-vulnerability-response-window); it is not
closed by these developer attestations.

## Maintenance

Re-evaluate against the live form at registration. Preserve pinned evidence and
dated negative outcomes; refresh these answers when releases, fixes or practices
change. Keep the assurance report/PDF and dated audits historical unless a
separately dated update is prepared. None of the proposed answers establishes
third-party certification or delegates the final attestation decision.
