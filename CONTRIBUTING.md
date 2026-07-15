# Contributing notes

This is mostly a collection of notes and other tips.

## Fuck off with your LLMs

Yukigram has a **strict No LLM / No AI policy**,
adapted from [Pallene](https://github.com/pallene-lang/pallene#contributing):

- No LLMs for issues.
- No LLMs for patches / pull requests.
- No LLMs for comments on the bug tracker, including translation.
- English is encouraged, but not required.
    You are welcome to post in your native language
    and rely on others to have
    their own translation tools of choice to interpret your words.

The sole exception for LLM-assisted contributions
is granted to upstream code
and patches based explicitly on it
*without* additional LLM usage.
This is needed to keep the fork up-to-date,
as maintaining a pre-LLM version
and porting new features is nearly impossible,
and it risks being left behind,
i.e. not allowing new sessions to be created.

Yukigram has no intention of completely ripping out
AI code from Telegram Desktop sources,
or has no intention of diverging codebases
purely for pragmatic reasons.

Initial Yukigram patches are believed to be slop-free,
as they were developed either by me
or long before the so-called vibe coding became popular.

**This project is proudly made by real humans.**

Thank you for not wasting my time.

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
../yukigram/s/flatten
git worktree add ../yukigram-worktree
```

### Scripts

Folder `s` contains a collection of mildly useful scripts.

#### `absorb`

A wrapper around [`git-absorb`] already set up for Yukigram.

[`git-absorb`]: https://github.com/tummychow/git-absorb

#### `flatten`

Flatten all the submodules in the current directory.
Current directory must be a top-level repository,
i.e. `.git` must be a directory.

#### `rebase`

Rebase helper for rebasing everything after submodule flattening.
Can take additional arguments, e.g.
```shell
cd tdesktop
../yukigram/s/rebase --interactive
```
can be used for commit reordering.

#### `format-patch`

`git format-patch` wrapper that formats everything after submodule flattening.

#### `patchset-version`

Updates patchset version and other metadata.

```shell
cd yukigram
s/patchset-version v6.8.2.0 # creates a normal release
s/patchset-version v6.8.3.2-beta # creates a pre-releases
```

This will create a commit and a tag.
Nothing will be pushed.

This expects both `yukigram` and `tdesktop`
to be in a relatively clean state.

Do not create a normal release
without adding a pre-release immediately before.
This allows double-checking
the correctness of release
before publishing the release itself
and "maining" beta versions
instead of "dual-wielding" both beta and stable.

The following command sequence
is recommended for creating a release:

```shell
cd yukigram

s/patchset-version v6.8.2.0-rc.1
git push; git push --tags
# manually run a workflow *from tag* with cachix and pre-release enabled
# wait for the run to succeed
# test beta
# if the beta was a failure, repeat with incremented rc.N

s/patchset-version v6.8.2.0
git push; git push --tags
# wait for the run to succeed
# test release just in case
```

#### `tdesktop-version`

Rebases the patchset to another tdesktop version.

```shell
cd yukigram
s/tdesktop-version v6.8.3
```

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
for p in ../yukigram/tdesktop/cur/*.patch; do
    printf '==== %s ====\n' "$p"
    patch -p1 <"$p"
done
```

Batch-applying patches is broken.

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
../yukigram/s/flatten
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
Use `../yukigram/s/rebase -i`
to reorder patches if needed.

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

> Try using `../yukigram/s/absorb` to create fixup commits automatically

Use fixup-commits to avoid rebasing every minute:

```shell
cd tdesktop
git log --oneline # determine relevant commit id
git commit --fixup COMMIT
```

To apply all fixups:

```shell
cd tdesktop
../yukigram/s/rebase
```

## Formatting patches

```shell
cd yukigram
../yukigram/s/format-patch
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

## Porting to newer tdesktop versions

Use `tdesktop-version.sh` and follow its prompts.

After the patchset has been applied,
update its version with `patchset-version.sh`.

## Overnight Nix builds

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
