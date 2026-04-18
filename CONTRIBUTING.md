# Contributing notes

## Porting to newer tdesktop versions

Patchset supports only one version out of the box.
This version is indicated in tag name.
For updating patchset to newer versions, use

```shell
git clone https://github.com/telegramdesktop/tdesktop && cd tdesktop
TAG=v6.7.3 # Do not skip patch and pre-release versions
git checkout $TAG && git submodule update --recursive && git am -3 ../yukigram/tdesktop/
# fix am conflicts
git format-patch --zero-commit -N -o ../yukigram/tdesktop/cur --base $TAG $TAG
cd ../yukigram && git add . && git commit -m "$TAG: patches only"
```

If any patches were dropped, reordered, or added,
please change the lists in the README and `REUSE.toml` accordingly.

If both nix and flatpak packages are updated,
commit message can be changed to simply `$TAG`,
dropping "patches only".

Commits with "patches only" mark are *not* tested
and may contain bugs fixed in next commits.

A tag should be added when the version is sufficiently tested
and is generally ready to be used.

### Updating Nix package

1. change version in `package.nix` and set hash to `lib.fakeHash`
2. fail a build once to get the correct hash
3. (optional) build again with `nix-build --argstr appId io.github.yukigram.devel`

### Updating Flatpak manifest

1. update tdesktop version in `.github/workflows/bincache.yml`
2. go to [org.telegram.desktop] and update changed permissions

[org.telegram.desktop]: https://github.com/flathub/org.telegram.desktop

### Updating build support

1. check [centos_env] for latest tag and update in `build.sh`
2. check `Telegram/CMakeLists.txt` and update `install.sh`

[centos_env]: https://github.com/telegramdesktop/tdesktop/pkgs/container/tdesktop%2Fcentos_env/versions

### Updating patchset version

1. change title of about box to reflect new version
    in `Telegram/SourceFiles/boxes/about_box.cpp`
2. tag a new version with increased fourth component
    (v6.7.5 -> v6.7.5.1 -> v6.7.5.2)
3. push `main` branch, and then push corresponding tag

## Incremental builds

The following assumes the following directory structure:
- `yukigram`, this repo.
- `tdesktop`, upstream Telegram Desktop.
- `yukigram-worktree`, a [git worktree][git-worktree] of `tdesktop`.

[git-worktree]: https://git-scm.com/docs/git-worktree

One-time preparation:

```shell
cd yukigram
nix-build local.nix --out-link local
```

Builds:

```shell
cd yukigram-worktree
git checkout --detach $COMMIT && git submodule update --recursive
CONFIG=Debug ./build.sh
```

Run:

```shell
cd yukigram
local/bin/yukigram
```

Data is stored somewhere under `~/.var/app/io.github.yukigram.devel`.

## Manual flatpak builds

```shell
cd yukigram-worktree
./build.sh
./install.sh
cd ../yukigram/flatpak
flatpak-builder --force-clean build io.github.yukigram.yml
```

## Installing previous versions from artifacts

### with flatpak

Make a backup of your data!
Downgrading versions is not supported.

1. Download artifact named `flatpak-x86_64` and unpack
2. `flatpak install --user .../flatpak-x86_64/ io.github.yukigram`

For development versions, use `io.github.yukigram.devel`
