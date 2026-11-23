# Owner attestations

These statements give the developer-knowledge attestations required by the
OpenSSF Best Practices criteria
[`know_secure_design`](https://www.bestpractices.dev/en/criteria/0#0.know_secure_design)
and [`know_common_errors`](https://www.bestpractices.dev/en/criteria/0#0.know_common_errors)
for **rust-mirror** and **rust-mirror-gui**. Each is a personal statement made by
the person named below. They cover that person's knowledge and how they apply it,
not a claim that the projects are free of vulnerabilities. The supporting evidence
for each project is in the [Best Practices answers](BEST-PRACTICES-ANSWERS.md) and
the [security assurance report](SECURITY-ASSURANCE.md).

## Secure design

I, Joey Huckabee (GitHub: joey-huckabee), am the owner and lead maintainer of
the Rust Commons projects rust-mirror and rust-mirror-gui. I set their design and
security requirements, review and approve every change, and authorize and approve
every release.

I have worked as a secure software lifecycle practitioner for 15 years, applying
security across requirements, design, implementation, testing, release and
maintenance. I am not currently certified by ISC2 (CSSLP) or any other
certifying body; this statement rests on that practical experience.

As of 22 November 2026, I know how to design secure software, and I understand
and apply the following principles to these projects:

1. **Economy of mechanism:** the projects are kept small and simple. Each new
   dependency requires my explicit approval, and trust decisions are delegated to
   well-reviewed libraries such as rustls instead of being reimplemented.
2. **Fail-safe defaults:** TLS certificate verification is always on, redirects
   and proxy discovery are off unless explicitly configured, and any mismatch in a
   hash, path, plan or release check stops the operation rather than continuing.
3. **Complete mediation:** every downloaded file is verified against its expected
   digest, publication re-checks the destination before each upload, and the
   release pipeline re-checks the tag, files and checksums at every stage.
4. **Open design:** the code, threat model, security assurance report and release
   process are public. Security does not depend on keeping the design secret.
5. **Separation of privilege:** publishing to crates.io requires an annotated
   release tag on main, passing CI, an automated release gate and my separate
   approval in a protected environment. Building, signing and publishing are
   separate jobs.
6. **Least privilege:** workflows default to read-only, and each job is granted
   only the permissions it needs. Publishing uses short-lived Trusted Publishing
   tokens instead of stored credentials, and no third-party code runs in the job
   that can request one.
7. **Least common mechanism:** the desktop app runs all mirroring work in a
   separate worker process, and per-machine network settings and secrets are kept
   apart from shared mirror configuration.
8. **Psychological acceptability:** users approve a complete saved plan once
   instead of item by item, refusals explain what failed and why, and each release
   prints the exact command to verify its provenance.
9. **Limited attack surface:** the tools contact only fixed official origins and
   explicitly configured destinations, run no external package manager at runtime,
   and expose no network service.
10. **Input validation with allowlists:** inputs are checked against explicit
    allowlists, including permitted hosts, contained file paths, expected release
    files and crates.io-only dependency sources, and anything not allowed is
    refused.

This statement concerns my knowledge and how I apply it. It is not a claim that
the projects are free of vulnerabilities.

## Common errors

I, Joey Huckabee (GitHub: joey-huckabee), owner and lead maintainer of
rust-mirror and rust-mirror-gui, draw on 15 years as a secure software lifecycle
practitioner. I am not currently certified by ISC2 (CSSLP) or any other
certifying body.

As of 22 November 2026, I know the following kinds of error that lead to
vulnerabilities in software of this type, and at least one way to prevent or
mitigate each one, as applied in these projects:

| Kind of error | How it is prevented or mitigated |
| --- | --- |
| Path traversal and unsafe file or link handling | Resolve every path, require it to stay inside its allowed directory, refuse `..`, unexpected links and unexpected entries, and verify the full file set before use. |
| Command and argument injection | Pass programs and arguments as separate lists, never build shell commands from untrusted text, and validate the inputs that are accepted. |
| Server-side request forgery and missing authorization | Restrict network access to fixed official origins and explicitly configured destinations, and check each permitted operation. |
| Certificate validation mistakes and man-in-the-middle attacks | Keep TLS identity and chain verification always on, add only explicitly approved CA certificates, and provide no option to bypass verification. |
| Unchecked integrity, stale input and unsafe overwrites | Verify every file's digest, freeze approved metadata, re-hash resumed downloads, and refuse to overwrite published files. |
| Credential disclosure | Keep secrets out of command lines, saved settings and logs, pass them privately on standard input, redact output, and use short-lived tokens instead of stored credentials. |
| Resource exhaustion and stalled operations | Bound sizes, counts and retries, and use cancellation, idle timeouts and stall warnings. |
| Memory-safety and native-code errors | Use safe, bounds-checked Rust, and review unsafe code, native code and dependencies rather than assuming they are safe. |
| Supply-chain compromise | Pin every build action and tool to an exact version or commit, check dependencies against vulnerability databases, sign release provenance, and keep publishing credentials away from third-party build code. |

I do not claim that these mitigations eliminate every vulnerability. The
remaining limits are documented in the
[security assurance report](SECURITY-ASSURANCE.md#13-residual-risks-and-limitations).

Joey Huckabee
22 November 2026
