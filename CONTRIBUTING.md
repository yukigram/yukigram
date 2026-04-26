# Contributing notes

This is mostly a collection of notes and other tips.

## Setup

The following assumes the following directory structure:
- `yukigram`, this repo.
- `tdesktop`, upstream Telegram Desktop.
- `yukigram-worktree`, a [git worktree][git-worktree] of `tdesktop`.

[git-worktree]: https://git-scm.com/docs/git-worktree

This can be achieved with the following set of commands:

```shell
git clone https://github.com/yukigram/yukigram
git clone https://github.com/telegramdesktop/tdesktop
cd tdesktop
git submodule update --init --recursive
git checkout -b test
git worktree add ../yukigram-worktree
```

### Git hooks

#### pre-commit

Requires a relatively recent version of [`reuse` tool][reuse-tool]

```shell
ln -s ../../hooks/pre-commit .git/hooks
```

[reuse-tool]: https://codeberg.org/fsfe/reuse-tool

## Incremental builds

To use incremental builds under NixOS,
or to use Nixpak for isolation of built binary,
a one-time preparation is needed.

```shell
cd yukigram
nix-build local.nix --out-link local
```

Builds:

```shell
cd yukigram-worktree
git checkout --detach test && git submodule update --recursive
CONFIG=Debug ./build.sh
```

The `cd` to `yukigram-worktree` instead of `tdesktop` is load-bearing,
because git-rebase works on a tree and mangles more timestamps than needed,
and makes incremental builds horribly break.

Run:

```shell
cd yukigram
local/bin/yukigram
```

Data is stored somewhere under `~/.var/app/io.github.yukigram.devel`.

## Applying patchset over Telegram Desktop

Patchset supports only one version out of the box.
This version is indicated in tag names, commit names, and `base-commit` footer.

Patches are stored in a Maildir-like format,
and can be applied with [git am][git-am].
Three-way am is recommended to simplify conflicts.

[git-am]: https://git-scm.com/docs/git-am

```shell
TAG=v6.7.3
git reset --hard $TAG
git submodule update --init --recursive
git am -3 ../yukigram/tdesktop
# resolve conflicts
```

### Conflict resolution tips

- Be not afraid
- Enable [git-rerere]
- Maybe some more?

[git-rerere]: https://git-scm.com/docs/git-rerere

## Adding a new patch

Add a commit as you normally do.
Use `git rebase -i $TAG` to reorder patches if needed.
Yukigram "structure" patches,
such as "branding" or "build support"
should go before "feature" patches,
such as "wide messages" or "show message id".

Before committing patch to this repo,
please ensure the following is true:

1. The indentation of in patch hunks is consistent
1. New files have newline at the end
    unless otherwise required by tools
1. Patches list in README is updated accordingly
1. Missing features list in README is updated accordingly
1. REUSE.toml mentions the patch in relevant sections

## Fixing previous patches

Use fixup-commits to avoid rebasing every minute:

```shell
cd tdesktop
git log --oneline # determine relevant commit id
git commit --fixup COMMIT
```

To apply all fixups:

```shell
cd tdesktop
git rebase --interactive --autosquash $TAG
```

## Formatting patches

```shell
cd yukigram
git format-patch --zero-commit -N -o ../yukigram/tdesktop/cur --base $TAG $TAG
```

If patches were renamed or reordered,
`yukigram/tdesktop/cur` directory might need cleaning.

I use the following command before formatting patches
if I know that patches were reordered:

```shell
cd yukigram
rm tdesktop/cur/*.patch
```

Be aware that this command discards all uncommitted changes.

## Updating patchset version

1. change title of about box to reflect new version
    in `Telegram/SourceFiles/boxes/about_box.cpp`
2. tag a new version with increased fourth component
    (v6.7.5.0 -> v6.7.5.1 -> v6.7.5.2)
3. push `main` branch, and then push corresponding tag

## Porting to newer tdesktop versions

Proceed as if you were applying patches normally.
Update patchset version to new tdesktop version.
Once the patchset fully applies,
format patches and commit `$TAG: patches only`.

Commits with "patches only" mark are *not* tested
and may contain bugs fixed in next commits.

A tag should be added when the version is sufficiently tested
and is generally ready to be used.

### Updating build support

This will probably break incremental builds,
but is required to make environment consistent
with what upstream expects.

1. check [centos_env] for latest tag and update in `build.sh`
2. check `Telegram/CMakeLists.txt` and update `install.sh`

[centos_env]: https://github.com/telegramdesktop/tdesktop/pkgs/container/tdesktop%2Fcentos_env/versions

### Updating Flatpak build

1. update tdesktop version in `.github/workflows/bincache.yml`
2. go to [org.telegram.desktop] and update changed permissions

[org.telegram.desktop]: https://github.com/flathub/org.telegram.desktop

### Updating Nix package

1. change version in `package.nix` and set hash to `lib.fakeHash`
2. fail a build once to get the correct hash
3. (optional) build again with `nix-build --argstr appId io.github.yukigram.devel`

Before I have set incremental buils up for myself,
I used the following oneliner to support overnight builds:

```shell
gnome-session-inhibit --inhibit=idle --inhibit-only & nix-build --argstr appId io.github.yukigram.devel --show-trace; kill %%
```

## Manual flatpak builds

```shell
cd yukigram-worktree
./build.sh
./install.sh --prefix /app
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

### with nix binary cache

Do not run non-release nix builds from binary caches
without using `customNixpakConfig`!
Doing otherwise may leave your tdata in a corrupted state.

I think it is possible,
but I haven't confirmed it myself.
Can possibly be done with `python3 -m http.server`
and a right `extra-substituter` URL.
