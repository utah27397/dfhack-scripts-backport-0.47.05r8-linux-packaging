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

## Quick Start

Install from the shared APT repository. APT installs the exact required Dwarf
Fortress and DFHack packages automatically:

```sh
echo 'deb [arch=amd64 trusted=yes] https://utah27397.github.io/dwarf-fortress-0.47.05-apt-repository stable main' \
  | sudo tee /etc/apt/sources.list.d/df04705-packaging.list
sudo apt update
sudo apt install dfhack-scripts-backport-0.47.05+r8
```

Alternatively, download the latest release directly after installing the Dwarf
Fortress and DFHack packages:

```sh
curl -LO 'https://github.com/utah27397/dfhack-scripts-backport-0.47.05r8-linux-packaging/releases/latest/download/dfhack-scripts-backport-0.47.05+r8_0.47.05+r8+backport10b1c6b-1df04705.2_all.deb'
sudo apt install './dfhack-scripts-backport-0.47.05+r8_0.47.05+r8+backport10b1c6b-1df04705.2_all.deb'
```

Run DFHack with the backported script overlay:

```sh
dfhack
dwarffortress
```

The base DFHack package provides the `dwarffortress` routing options. With this
addon installed, the DFHack route includes the backported scripts:

```text
dwarffortress [--dfhack | --dfhack=true] [game args]
dwarffortress [--no-dfhack | --vanilla | --dfhack=false] [game args]
DFHACK=1 dwarffortress [game args]
DFHACK=0 dwarffortress [game args]
```

Examples:

```sh
dwarffortress --dfhack
dwarffortress --no-dfhack
dwarffortress --vanilla
DFHACK=0 dwarffortress
```

Build locally instead:

```sh
git clone --recursive https://github.com/utah27397/dfhack-scripts-backport-0.47.05r8-linux-packaging.git
cd dfhack-scripts-backport-0.47.05r8-linux-packaging
make build
sudo apt install '../dfhack-scripts-backport-0.47.05+r8_0.47.05+r8+backport10b1c6b-1df04705.2_all.deb'
```

Build the package:

```sh
git submodule update --init --recursive
make build
```

The default output path is:

```text
../dfhack-scripts-backport-0.47.05+r8_0.47.05+r8+backport10b1c6b-1df04705.2_all.deb
```

Inspect the pinned upstream source:

```sh
make source-info
```

Package metadata:

- Package: `dfhack-scripts-backport-0.47.05+r8`
- Version: `0.47.05+r8+backport10b1c6b-1df04705.2`
- Depends: `dfhack-0.47.05+r8 (= 0.47.05+r8-1df04705.2)`
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
