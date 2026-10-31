# rustcommons

Rust tooling and infrastructure for Linux compatibility and offline Rust development.

Start with [cargo-libc](https://github.com/rustcommons/cargo-libc) for the Cargo
workflow, or explore the supporting libraries and compatibility tests below.

## Linux compatibility and ABI crates

Tools and data for building Rust programs for older Linux systems and checking
their libc and kernel requirements.

| Repository | Purpose |
| --- | --- |
| [cargo-libc](https://github.com/rustcommons/cargo-libc) | Coordinates Cargo builds, checks, and tests for selected glibc environments on x86_64 Linux. Prepares link providers, inspects ELF requirements, and runs programs under kernel-availability simulation. |
| [linux-abi-tools](https://github.com/rustcommons/linux-abi-tools) | Rust crates for glibc ABI metadata and link providers, kernel syscall data and simulation, distribution target presets, and static binary inspection. |
| [glibc-abilists](https://github.com/rustcommons/glibc-abilists) | The GNU C Library's unmodified ABI lists for x86_64 Linux, collected from release tags with provenance records. Supplies symbol and version data to `linux-abi-tools`. |
| [glibc-provider](https://github.com/rustcommons/glibc-provider) | Recorded glibc sources, generated and installed headers, and compile commands for rebuilding a release's startup objects and nonshared archives. Supplies these inputs through the `glibc-provider-sources` crate. |

### How the pieces fit

`glibc-abilists` and `glibc-provider` supply ABI data and source inputs to
`linux-abi-tools`. Its crates prepare glibc link providers and provide the
inspection and kernel-simulation tools that `cargo-libc` uses to coordinate
compatibility builds, checks, and tests.

Static inspection and kernel-availability simulation help find incompatibilities;
they do not replace running and testing a program on its actual target systems.
See the [cargo-libc user guide](https://github.com/rustcommons/cargo-libc/blob/main/docs/USER-GUIDE.md)
and [linux-abi-tools workflows](https://github.com/rustcommons/linux-abi-tools/blob/main/docs/WORKFLOWS.md)
for usage and limits.

## Compatibility testing

[rust-musl-libc-compat-test](https://github.com/rustcommons/rust-musl-libc-compat-test)
is a separate, statically linked x86_64 musl executable for probing compatibility
on Linux hosts. It checks environment, filesystem, threading, networking, time,
process, and syscall behavior, with kernel-version gates for selected syscalls.
