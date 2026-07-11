# DFHack Scripts Backport Linux Packaging

This repository builds the Linux filesystem package for selected newer DFHack
scripts backported to DFHack `0.47.05-r8`.

The patched script source lives in the pinned submodule:

```text
upstream/scripts
```

That submodule points at the minimized `scripts-backport/0.47.05-r8` branch in
the `utah27397/scripts` fork. The branch is based on the scripts commit used by
DFHack `develop`, contains only the manifest-listed files, and has the
compatibility edits already applied. This repository only adds Debian package
metadata and the target install layout.

The package installs the generated scripts into:

```text
/opt/dfhack-scripts-backport-0.47.05r8/hack/scripts
```

The package does not overwrite files from `dfhack-0.47.05+r8`. The DFHack
backport package diverts `/usr/bin/dfhack` to
`/usr/bin/dfhack.dfhack-0.47.05+r8` and installs a replacement wrapper that
overlays this immutable addon tree into the per-user runtime tree.

Build the package:

```sh
git submodule update --init --recursive
make build
```

The default output path is:

```text
../dfhack-scripts-backport-0.47.05+r8_0.47.05+r8+backport10b1c6b-1df04705.1_all.deb
```

Inspect the pinned upstream source:

```sh
make source-info
```

Package metadata:

- Package: `dfhack-scripts-backport-0.47.05+r8`
- Version: `0.47.05+r8+backport10b1c6b-1df04705.1`
- Depends: `dfhack-0.47.05+r8 (= 0.47.05+r8-1df04705.1)`
- Enhances: `dfhack-0.47.05+r8`

Removal restores the original `dfhack-0.47.05+r8` wrapper diversion.

## Latest Release

Download the current Debian package from the
[latest GitHub release](https://github.com/utah27397/dfhack-scripts-backport-0.47.05r8-linux-packaging/releases/latest).

## Related Repositories

- [Dwarf Fortress 0.47.05 Linux x86_64 packaging](https://github.com/utah27397/dwarf-fortress-0.47.05-linux-x86_64-packaging)
- [DFHack 0.47.05-r8 Linux x86_64 packaging](https://github.com/utah27397/dfhack-0.47.05r8-linux-x86_64-packaging)
- [DFHack scripts backport Linux packaging](https://github.com/utah27397/dfhack-scripts-backport-0.47.05r8-linux-packaging)
- [Dwarf Therapist v41.2.5 Linux x86_64 packaging](https://github.com/utah27397/dwarf-therapist-v41.2.5-linux-x86_64-packaging)
