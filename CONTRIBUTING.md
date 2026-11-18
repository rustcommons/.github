# Contributing to Rust Commons

These are the default contribution guidelines for Rust Commons repositories that
do not provide their own `CONTRIBUTING.md`. Follow the affected repository's
README and primary `AGENTS.md` for its scope, commands and specific requirements.
This guide does not replace a repository's license or release policy.

## Obtain the software and source

Find the project in the [Rust Commons repositories](https://github.com/orgs/rustcommons/repositories).
Its README links supported platforms, prerequisites, installation, guides and
versioned releases. Where published, use its linked GitHub Releases or crates.io
page and docs.rs documentation. Verify downloaded releases using that project's
checksum and attestation instructions; not every historical release has the same
evidence. Use the repository's source, not an unverified third-party download.

To contribute, fork the affected repository or create an authorized topic branch.
Clone its HTTPS URL and follow its README/AGENTS setup instructions. Do not assume
that all repositories produce a binary, crate or software release; `.github` is a
documentation and community-policy repository.

## Report bugs and request features

Use **Issues in the affected repository**, rather than a different project or the
organization profile repository. Search existing issues first. English reports
and discussion are welcome.

For a bug, include the exact product/version or commit, platform, minimal
reproduction, expected and actual behavior, and relevant sanitized output. For a
feature request, explain the problem, proposed behavior, constraints and a useful
example. Label the request as a bug or enhancement when the repository allows it;
otherwise state the type in the issue title/body. Maintainers may request details,
redirect a report or decline a proposal. An acknowledgment is not a fix or delivery
promise. The [dated response audit](https://github.com/rustcommons/.github/blob/main/docs/RESPONSE-HISTORY-AUDIT.md)
records evidence and limits separately from response targets.

**Report suspected vulnerabilities privately.** In the affected repository choose
Security → Advisories → Report a vulnerability. Follow its security policy or the
[organization default SECURITY.md](https://github.com/rustcommons/.github/blob/main/SECURITY.md).
Do not include exploit details, credentials or personal data in a public issue or
PR. The policy defines private reporting, response targets and disclosure.

## Propose and validate changes

- Open an issue to discuss substantial scope/interface changes before investing
  in an implementation. Keep the PR focused and explain the problem, behavior
  change, validation and remaining gaps.
- All changes to `main` require a PR. Work on a topic branch; do not push directly
  to main, force-push or use an administrator bypass for routine
  work. Preserve concurrent changes and never move existing release tags.
- Never put CI-skip directives in commit or merge messages, even for documentation.
  Keep CodeQL and applicable checks running; scope jobs and cancel superseded PR
  runs to reduce load instead.
- Read `AGENTS.md` before editing. Use the repository's formatting, lint and test
  commands, dependency policy and requirements index. Obtain approval for new
  dependencies; pin third-party Actions to full commits with version comments and
  keep workflow permissions read-only except for necessary job-scoped grants.
- **Major new functionality must include automated tests.** Add tests with the
  functionality, and identify their commands and results in the PR. For bug
  fixes, add an appropriate regression test where applicable. Keep security
  refusal and negative-control tests when changing security boundaries. Passing
  unrelated tests does not establish coverage of a new feature.
- Update affected documentation, stable requirement IDs and trace links with the
  change. Separate implemented behavior, planned work and unverified cases.
  Preserve dated validation and immutable published-package evidence.
- For documentation-only changes, check source/command consistency, links,
  rendering and `git diff --check`; do not run unrelated product builds. For code
  changes, run applicable checks and report unavailable platform evidence
  explicitly. Follow the repository's core CI and qualification gates; do not
  claim an unrun check passed or weaken a gate to make a PR green.
- Keep credentials, `.env` files, private reports and sensitive logs out of commits.
  Commit messages and PR descriptions must contain no tool attribution or
  generated-by footer.

Maintainers review and merge through PRs. Releases, protected tags, package
publishing and production changes require their separate authorization and
release process; submitting a PR does not authorize those actions. See the shared
[documentation conventions](https://github.com/rustcommons/.github/blob/main/docs/DOCUMENTATION.md)
and [security baseline](https://github.com/rustcommons/.github/blob/main/docs/SECURITY-BASELINE.md).
