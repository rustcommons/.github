# Rust Commons documentation conventions

This is the shared maintainer convention for the eight Rust Commons repositories.
It organizes documentation and evidence; it adds no product capabilities or
compatibility guarantees. Each repository's `AGENTS.md` is its primary instruction
source; `CLAUDE.md` remains a short shim pointing to it, with no duplicate rules
or reference cycle. Preserve existing Working conventions and Git conventions.

## Reader paths and authority

- **README:** purpose, confirmed scope, prerequisites, setup or installation,
  a minimal supported example, and links to maintained guides. For a
  documentation-only repository, state that no runtime setup is required.
- **Maintained user and reference docs:** detailed workflows, command and API
  contracts, supported inputs, outputs, limits, and troubleshooting. Match actual
  source, command help, manifest crate names, and repository names. Distinguish
  repository names from published crate names and versions.
- **Architecture:** current components, data sources, dependency direction,
  interfaces, and design constraints. Link to authoritative code and provenance.
- **Roadmap:** planned or deferred work, clearly separate from shipped behavior.
- **Dated validation and release records:** exact commands or CI runs, environment,
  versions or revisions, date, results, and limitations. Keep historical outcomes
  intact; link newer evidence separately. A current guide may supersede a workflow
  without rewriting a historical record.

Use existing documents where possible; these reader paths do not mandate empty
architecture, roadmap, or release files. The requirements index's Documentation
map identifies maintained guides, historical records, and paths not applicable
to that repository. Verify links and anchors, including links across repositories.

Document applicable toolchain and system prerequisites, supported platforms and
architectures, static/dynamic linkage assumptions, external data or native
library dependencies, and licensing/provenance obligations. Cite authoritative
sources and state gaps or unsupported cases explicitly. Do not infer support
from a repository name, a successful host test, static inspection, or simulation;
none certifies runtime compatibility on untested target systems.

## Architecture diagrams

Use a small, editable diagram where it helps explain implemented components,
dependency direction, data flow, or a trust boundary. Prefer Mermaid in an
existing maintained architecture or guide document; do not add empty diagram
files or diagrams of unapproved placeholder designs.

Explain what arrows mean and distinguish build-time collection, library/API
consumption, and runtime execution where they differ. Keep native host and target
boundaries visible when relevant. Label planned or deferred components explicitly
and separately from implemented paths; inspection and simulation must not appear
to establish real-target qualification.

Link diagram explanations to authoritative source and existing requirement IDs.
Include the containing document in the requirements index's Documentation map.
Diagrams illustrate those contracts; they do not introduce new requirements or
replace source, provenance, licensing, or validation evidence. A documentation or
placeholder repository can record architecture diagrams as Not applicable when
it has no implemented product architecture to explain.

When affected components or interfaces change, review the diagram and its trace
links with the prose. Check syntax, inspect an actual rendered preview for
readable labels and unambiguous arrows, and record the source revision and render
method in the change evidence. Rendering validates presentation, not behavior.
Keep historical diagrams identifiable as snapshots instead of silently updating
their recorded outcomes.

The dated [architecture diagram audit](ARCHITECTURE-DIAGRAMS.md) records this
convention's initial follow-up across all eight repositories.

## Requirements index

Every repository maintains `docs/REQUIREMENTS.md` with these sections, in order:
**Scope and sources**, **Requirements**, **Documentation map**, **Maintenance**.
The Requirements table uses exactly these columns:

| ID | Requirement and source | Implementation / documentation | Verification evidence | Status and gaps |
| --- | --- | --- | --- | --- |

Allocate stable IDs using the repository prefix and a numeric suffix (for example,
`ORG-REQ-001`). Never renumber, reuse, or silently remove an ID. Preserve existing
identifiers, including legacy IDs; cross-reference aliases when needed.

| Repository | Prefix |
| --- | --- |
| cargo-libc | CL-REQ |
| linux-abi-tools | LAT-REQ |
| glibc-abilists | GA-REQ |
| glibc-provider | GP-REQ |
| rust-musl-libc-compat-test | MUSL-REQ |
| .github | ORG-REQ |
| rustup-offline-mirror | ROM-REQ |
| cargo-binpack | CB-REQ |

These are current repository names, not approval to list placeholders in the
public organization profile or commitments to their eventual product naming.
Placeholder repositories record only confirmed documentation, scope, and
maintenance requirements. Mark implementation verification **Not applicable**;
do not invent mirror or package-management contracts.

Trace each confirmed requirement to an authoritative instruction, decision,
source, or manifest, then to implementing code or documentation and bounded
verification. Name the exact test, command, CI run, revision/ref, and date as
applicable. State which environment and behavior the evidence covers, and name
missing evidence explicitly. Source inspection alone does not prove runtime
behavior. Use only these status labels, with the boundary or gap beside the label:

- **Verified:** bounded, named evidence supports the stated requirement.
- **Implemented—partial verification:** implementation or documentation exists;
  specify the unverified part.
- **Planned:** confirmed future work, with no claim of implementation.
- **Deferred:** confirmed work explicitly postponed; cite the decision.
- **Not applicable:** an explicit scope exclusion; explain why.

## Freshness, releases, and validation

Update affected requirements, guides, references, and trace links together when
behavior, scope, interfaces, prerequisites, or validation changes. Use the README
as the entry point rather than copying detailed workflows into multiple files.
Record every staleness fix and remaining gap in the change description.

Tie release evidence to exact package versions and immutable commits, tags, or
CI run references. Published crate contents and their versioned documentation
are immutable: editing repository Markdown does not repair a published crate's
docs. Record that gap and use the separately authorized release process when a
new package version is needed. Never rewrite historical outcomes as current or
alter existing release assets or tags for documentation freshness.

For documentation-only changes, inspect authoritative source and documented
commands, check links and rendering, and run `git diff --check`. Run additional
builds or tests only if changed examples, package contents, or behavior require
them. Keep evidence specific; successful Markdown checks are not a product audit.

## Release notes and changelogs

Follow the [release documentation convention](RELEASING.md). Versioned software
repositories maintain a root changelog, reviewed notes and GitHub Releases in
addition to detailed qualification records. Shared AGENTS rules and automated
checks make these explicit completion gates; profile/placeholder repositories
remain Not applicable until they ship software.

## Adoption snapshot

On 2026-11-01, GitHub Contents API lookups for `docs/REQUIREMENTS.md` on the
default branches of the seven repositories other than `.github` returned 404.
This change introduces the [.github index](REQUIREMENTS.md). Other repository
indexes are being prepared independently; this snapshot does not claim their
audits or adoption are complete. Later adoption should be recorded with exact
repository revisions and dates rather than changing this historical observation.

The subsequent [dated adoption record](ADOPTION.md) tracks confirmed merged
revisions, counts and evidence boundaries separately from
this initial observation.
