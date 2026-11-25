# Security policy

This is the default policy for Rust Commons repositories without their own
`SECURITY.md`. Repository-specific policies take precedence.

## Supported versions and scope

Security fixes target the **latest release of each product**. Older releases are
unsupported; upgrade to the latest release before checking whether a fix applies.
A report affecting an older release is still useful if the latest release is
also affected. Repositories without a released product accept reports about their
current default branch, documentation and workflows.

Reports may concern CLI or GUI binaries, published crates, dependencies as used
by our products, or CI workflows and release infrastructure. State the exact
repository, version or commit, platform, installation source and affected artifact.
This policy does not certify a platform, release artifact or dependency as secure.

## Report privately

Use **Security → Advisories → Report a vulnerability** in the affected
[rustcommons repository](https://github.com/orgs/rustcommons/repositories).
GitHub private vulnerability reporting is enabled across the organization.
For this repository, [report privately here](https://github.com/rustcommons/.github/security/advisories/new).
See [GitHub's reporting instructions](https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/report-privately).
Do not open a public issue or pull request containing exploit details or secrets.

Include a minimal reproduction, impact, affected versions, prerequisites and any
suggested mitigation. Redact credentials and personal data. Test only systems you
own or have permission to test; avoid disruption or accessing others' data.

## Response targets

We aim to acknowledge reports within **3 business days** and complete initial
triage within **10 business days** of receipt (business days are Monday–Friday,
excluding maintainer public holidays). During triage we agree severity, mitigation,
and a target fix/advisory date with the reporter. Targets after triage are:

| Severity | Fix or mitigation and advisory target |
| --- | --- |
| Critical | Within 7 calendar days; prioritize immediate containment. |
| High | Within 30 calendar days. |
| Medium | Within 90 calendar days. |
| Low | Next suitable maintenance release, with an explicit target date agreed during triage. |

These are response targets, not guarantees. If investigation, dependency fixes or
validation require more time, we explain the delay and revise the date in the
private advisory. An urgent mitigation may precede the full fix.

## Coordinated disclosure

Keep details in the private advisory while we investigate and prepare a fix.
Agree a disclosure date with maintainers; coordinate affected dependencies when
needed. We aim to publish an advisory with affected/fixed versions, impact and
mitigations alongside the fix, crediting reporters with their consent. Active
exploitation may require an earlier advisory or mitigation. Discuss any proposed
earlier disclosure in the private report so users can be protected promptly.

## Verify a release

Use the product repository's release instructions and exact version/tag. When a
binary release provides `SHA256SUMS`, download that file and its listed artifacts
from the same official release, then run in the download directory:

```sh
sha256sum --check SHA256SUMS
```

A checksum detects mismatched bytes; it does not independently authenticate the
publisher. Where an artifact has a GitHub attestation, verify the downloaded file
against its expected repository (replace both placeholders):

```sh
gh attestation verify ./ARTIFACT --repo rustcommons/REPOSITORY
```

### OpenPGP signature

Releases published after 2026-11-25 also attach `SHA256SUMS.asc`, an OpenPGP
signature of `SHA256SUMS` made with the Rust Commons release-signing key:

- Identity: `Rust Commons Release Signing`
- Primary key fingerprint: **`B281 C301 0A76 A117 37B4  D066 C739 6F6E A764 7CC6`**
- Public key: [docs/RELEASE-SIGNING-KEY.asc](docs/RELEASE-SIGNING-KEY.asc)

Import the key once, confirm the fingerprint matches exactly, then verify:

```sh
gpg --import RELEASE-SIGNING-KEY.asc
gpg --fingerprint B281C3010A76A11737B4D066C7396F6EA7647CC6
gpg --verify SHA256SUMS.asc SHA256SUMS
sha256sum --check SHA256SUMS
```

`SHA256SUMS` lists every release file, so one valid signature plus a passing
checksum check covers them all. The signing subkey is held only by the release
pipeline behind the owner's approval; the primary key is kept offline. Earlier
releases have no `.asc`: verify those with checksums and GitHub attestations.

### GitHub attestation

Check the reported source commit, workflow identity and artifact digest against
the intended release. Follow [GitHub CLI verification guidance](https://cli.github.com/manual/gh_attestation_verify)
for additional identity constraints. Missing checksums or attestations are a
verification gap, not a successful verification or a SLSA level claim. Historical
releases may lack these assets. Published crates use the registry checksum and
repository-specific package verification instructions; do not assume a binary
checksum file covers a crate. This documentation repository ships no binaries or
crates and makes no release-provenance claim.

Maintainers: see the [organization security baseline](https://github.com/rustcommons/.github/blob/main/docs/SECURITY-BASELINE.md)
for required controls and their applicability.
