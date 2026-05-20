# Contributing notes

This is mostly a collection of notes and other tips.

## Setup

The following assumes the following directory structure:
- `yukigram`, this repo.
- `tdesktop`, upstream Telegram Desktop with flattened submodules.
- `yukigram-worktree`, a [git worktree][git-worktree] of `tdesktop`.

[git-worktree]: https://git-scm.com/docs/git-worktree

This can be achieved with the following set of commands:

```shell
git clone https://github.com/yukigram/yukigram
git clone https://github.com/telegramdesktop/tdesktop
cd tdesktop
git submodule update --init --recursive
git checkout -b test
../yukigram/s/flatten.sh
git worktree add ../yukigram-worktree
```

### Scripts

Folder `s` contains a collection of mildly useful scripts.

#### `flatten.sh`

Flatten all the submodules in the current directory.
Current directory must be a top-level repository,
i.e. `.git` must be a directory.

### Git hooks

#### pre-commit

Requires a relatively recent version of [`reuse` tool][reuse-tool]

```shell
ln -s ../../hooks/pre-commit .git/hooks
```

[reuse-tool]: https://codeberg.org/fsfe/reuse-tool

## Incremental builds

### Build

```shell
cd yukigram-worktree
git checkout --detach test
DEVEL=true CONFIG=Debug ./build.sh
```

The `cd` to `yukigram-worktree` instead of `tdesktop` is load-bearing,
because git-rebase works on a tree and mangles more timestamps than needed,
and makes incremental builds horribly break.

### Install

Reinstall is only needed if `share` directory changes.

```shell
cd yukigram-worktree
rm -r app || true
CONFIG=Debug ./install.sh --prefix /app
strip -s app/bin/yukigram
```

Rebuild `local` after `app/share` changes.

```shell
cd yukigram
nix-build local.nix --out-link local
```

### Run

```shell
cd yukigram
local/bin/yukigram
```

Data is stored somewhere under `~/.var/app/io.github.yukigram.devel`.

## Applying patchset over Telegram Desktop

Patchset supports only one version out of the box.
This version is indicated in tag names, commit names, and `base-commit` footer.

`prerequisite-patch-id` footer shows
`#flatten` commit's stable patch id.

### Applying with `patch`

This patchset can be applied with `patch`
over a tdesktop clone with all submodules,
e.g. from `tdesktop-$version-full` release archive.

```shell
cd tdesktop-full
cat ../yukigram/tdesktop/cur/*.patch | patch -p1
```

It is not recommended to use `patch` for development.

### Applying with `git-am`

Patches are stored in a Maildir-like format,
and can be applied with [git am][git-am].
Three-way am is recommended to simplify conflicts.

[git-am]: https://git-scm.com/docs/git-am

```shell
TAG=v6.7.3
git reset --hard $TAG
git submodule update --init --recursive
../yukigram/s/flatten.sh
git am -3 ../yukigram/tdesktop
# resolve conflicts
```

### Conflict resolution tips

- Be not afraid
- Enable [git-rerere]
- Maybe some more?

[git-rerere]: https://git-scm.com/docs/git-rerere

## Adding a new patch

Once you've applied current patchset,
you can add a commit as you normally do.
Use `git rebase -i HEAD^{/#flatten}`
to reorder patches if needed.

Use of `HEAD^{/#flatten}` is needed
to avoid repeating `$TAG`
and therefore make commands version-independent,
and to avoid rebasing over "submodule flattening"
which, if done, yields weird warnings
about submodule directories not being empty.

Patches, except for Yukigram structure ones
(such as "branding" or "build support"),
should have categories in their names.
Reordering patches is discouraged
unless absolutely necessary
as not to create a lot of empty diffs.

Categorized patches that add user-facing options
should be marked with `(Opt)`.

Before committing patch to this repo,
please ensure the following is true:

1. Every patch has a category
1. The indentation of in patch hunks is consistent
1. New files have newline at the end
    unless otherwise required by tools
1. Patches list in FEATURES is updated accordingly
1. Missing features list in FEATURES is updated accordingly
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
git rebase --interactive --autosquash HEAD^{/#flatten}
```

## Formatting patches

```shell
cd yukigram
git format-patch --zero-commit -N -o ../yukigram/tdesktop/cur --base HEAD^{/#flatten}{^,}
```

`--zero-commit` is needed
to make first line of `.patch` files
(the `From ... Mon Sep 17 00:00:00 2001` line)
stable across rebases and reapplies.

`-N` disables patch numbering,
making `[PATCH 45/67]` in subject line
become `[PATCH]`,
which allows patches to be
more stable across reorders and patch additions.

`--base HEAD^{/#flatten}{^,}` sets

- base commit to `HEAD^{/#flatten}^`,
    i.e. the commit immediately preceding the submodule flattening
- formatted commits range to `HEAD^{/#flatten}`,
    i.e. all commits reachable from `HEAD`,
    but not from `HEAD^{/#flatten}`,
    or, in plain words,
    everything after the submodule flattening.

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
1. change unwrapped package version
    and `DEVEL` value
    in `package.nix`
1. adjust `.devel` suffix in `appId`
    in `nixpak.nix`
1. tag a new version with increased fourth component
    (v6.7.5.0 -> v6.7.5.1 -> v6.7.5.2)
1. push `main` branch,
    and then push corresponding tag
1. (post-update only)
    once nixpak and flatpak builds are somewhat tested,
    post release announcement
    in [Yukigram channel]

[Yukigram channel]: https://t.me/yukigram

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

### Updating PostmarketOS bulid

1. update tdestkop version in `.github/workflows/bincache.yml`

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

Make a backup of your data!
Downgrading versions is not supported.

### with flatpak

1. Download release asset `flatpak-x86_64` and unpack
2. `flatpak install --user .../flatpak-x86_64/ io.github.yukigram`

For development versions, use `io.github.yukigram.devel`

### with nix binary cache

1. Download release asset `nixos-$arch` and unpack
2. `cd .../nixos-$arch && python3 -m http.server`
3. Add `--extra-substituters http://127.0.0.1:8000` to nix command line
    (don't forget to be a trusted user,
    and don't forget to add a trusted key
    if it's not added by other means,
    e.g. by using flake in this repo)
