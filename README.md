# Yukigram, a collection of tdesktop patches

Telegram Desktop, minus the bullshit, plus the features.

[Full feature list] /
[Known bugs] /
[Contributing notes] /
[Licensing information] /
[Telegram channel]

[Full feature list]: ./FEATURES.md
[Known bugs]: ./BUGS.md
[Contributing notes]: ./CONTRIBUTING.md
[Licensing information]: ./LICENSING.md
[Telegram channel]: https://t.me/yukigram

## Patches?

Most clients (all of them?) are _forks_,
and most forks don't bother rebasing their changes over and over,
and instead opt for introducing merge commits
to be on par with upstream changes.
This makes history and changes harder to track and audit.
Patch-based approach is, in a way,
a rebase-workflow but without commits,
and with [range-diff] included,
allowing to more precisely track how patches evolve over time
and understand code easier.

Please inspect these patches yourselves to make sure that you really trust the code.

Some more information can be found in [Contributing notes].

[range-diff]: https://git-scm.com/docs/git-range-diff

## Installation

Do not blindly trust our binary caches.
They are built by GitHub Actions,
and are supposed to be reproducible, though.

Windows and macOS are *not* supported.

Consider using isolated packages
and reviewing and refining their permissions
(with e.g. [Flatseal] for flatpak
or with [custom Nixpak options] for nixpak)
instead of plain binaries.

[Flatseal]: https://github.com/tchx84/Flatseal
[custom Nixpak options]: #custom-options

### with flatpak

```shell
flatpak remote-add --user --if-not-exists yukigram https://yukigram.github.io/yukigram/index.flatpakrepo
flatpak install --user io.github.yukigram
```

### with nix

#### binary caches setup

Add `yukigram-nixos-binary-cache:JY9MpP2ESUmPx3cfIpcSRpBK9HQ1/mzHemsvjv1aiYU=`
to `extra-trusted-public-keys`.

Add `https://yukigram.github.io/yukigram`
to `extra-substituters`.

Add `yukigram-official.cachix.org-1:PmmKVD/46LWDxfPWKol4rvoqvcdLqFq0aTtG/E1gdA8=`
to `extra-trusted-public-keys`
for previous and development versions.

Add `https://yukigram-official.cachix.org`
to `extra-substituters`
for previous and development versions.

If you use Nix to manage nix config,
activate a configuration with these settings at least once
before adding Yukigram to packages.

If you supply these options as command-line-arguments,
make sure to run builds from a trusted user,
otherwise binary caches won't work.

Binary caches are only built for tagged releases.
Track `release` branch instead of `master`
if your pinning tool does not support tracking tags.

Recommended flake input formats are:
- `github:yukigram/yukigram/release` for latest releases,
- `github:yukigram/yukigram/v6.7.8.1` for pinned releases,
- `github:yukigram/yukigram/beta` for latest pre-release.

Pre-release Nix builds are published
only to Cachix and release artifacts.

#### with nixpak

without flakes:
```nix
(import <yukigram> {}).packages.default
```

with flakes:
```nix
inputs.yukigram.packages.${system}.default
```

`default` can be replaced with `nixpak` for explicitness.

#### without nixpak

without flakes:
```nix
(import <yukigram> {}).packages.nonisolated
```

with flakes:
```nix
inputs.yukigram.packages.${system}.nonisolated
```

#### custom options

Custom nixpak options are required to launch Yukigram nixpak under X11.

```nix
let
  d = import <yukigram> {}; # without flakes
  d = inputs.yukigram.d.${system}; # with flakes
  yukigram = d.override (prev: {
    # customize nixpak
    nixpak.yukigram = prev.nixpak.yukigram.override {
      appId = "io.github.yukigram.backed";
      customNixpakConfig = {
        bubblewrap.sockets.x11 = true;
      }
    }

    # or bring your own patches (disables binary caches)
    packages.nonisolated = prev.packages.nonisolated.override (prev: {
      unwrapped = prev.unwrapped.overrideAttrs (prev: {
        patches = prev.patches ++ [./my-cool.patch];
      };
    };

    # or bring your own nixpkgs (may disable binary caches)
    sources.nixpkgs = <nixpkgs>;

    # or use a custom instance of nixpkgs (may disable binary caches)
    inputs.pkgs = import <nixpkgs> {};

    # or make nonisolated package the default one
    packages.default = prev.packages.nonisolated;
  });
in yukigram.packages.default;
```

### on PostmarketOS

#### repository installation

```shell
wget https://yukigram.github.io/yukigram/pmaports/yukigram-key/yukigram.github.io.rsa.pub -O /etc/apk/keys/yukigram.github.io.rsa.pub
echo https://yukigram.github.io/yukigram/packages/edge >> /etc/apk/repositories
apk update
apk add yukigram yukigram-key
```

#### direct .apk downloads

Download `yukigram-$ARCH.apk` from releases.

Not really recommended unless for quick checks,
as automatic updates are unsupported with bare `.apk` files.

### with other package manager

#### from binaries

Download `binary-$ARCH` from releases
and unpack it to `/usr/local/` or `~/.local/`.

Automatic updates are unsupported with this approach.

#### from source

Check your package manager's manual
on how to add patches to packages
and package Telegram Desktop (of correct version)
with your selection of patches.

The recommended way of applying patches
for building for repositories
is by using `patch`.
See [#applying-with-patch]
in contributing notes for details.

Unofficial packages that seem correct
and may be used instead of a manual from-source build:

- AUR package [`yukigram-desktop`][aur-yukigram]

[#applying-with-patch]: CONTRIBUTING.md#applying-with-patch
[aur-yukigram]: https://aur.archlinux.org/packages/yukigram-desktop

## Previous versions

Make a backup of your data!
Downgrading versions is not supported.

> [!IMPORTANT]
> Pre-release versions prior to 6.8.3.2
> had a fallback to these paths
> and could corrupt production tdata.
>
> Versions prior to 6.7.8.1 are NOT devel-aware.
> Running devel-oblivious development versions
> *will* corrupt production version's tdata.
>
> Installations of Yukigram prior to that version
> should migrate their data directory as follows.
>
> 1. Close Yukigram.
> 1. Update Yukigram to a recent enough version.
> 1. Rename `~/.TelegramDesktop` folder
>   to `${XDG_DATA_HOME:-~/.local/share}/io.github.yukigram`
>   (nonisolated package that was used for a dozen years).
> 1. Go to `${XDG_DATA_HOME:-~/.local/share}` (nonisolated package).
>   and rename `Yukigram` folder to `io.github.yukigram`.
> 1. Go to `~/.var/app/io.github.yukigram/data` (flatpak or nixpak)
>   and rename `Yukigram` folder to `io.github.yukigram`.
> 1. Go to `~/.var/app/io.github.yukigram.devel/data` (devel, flatpak or nixpak)
>   and rename `Yukigram` folder to `io.github.yukigram.devel`.
> 1. Go to `~/.var/app/io.github.yukigram.devel/data` (old nixpak with customNixpakConfig)
>   and rename `io.github.yukigram` folder to `io.github.yukigram.devel` if that folder doesn't yet exist.
> 1. Run Yukigram again.

### with flatpak

Download `flatpak-$ARCH` release asset and unpack it.

```shell
flatpak install --user .../flatpak-$ARCH io.github.yukigram
```

Substitute `io.github.yukigram`
with `io.github.yukigram.devel`
for development builds.

### with nix

Recent previous and development versions are cached at Cachix.

> [!NOTE]
> Versions prior to 6.8.2.1 are cached only on Cachix
> and may become inaccessible.

> [!CAUTION]
> Versions prior to 6.8.3.1 are NOT devel-aware
> and *will* corrupt your tdata.
> Running those without `customNixpakConfig` or `appId`
> is *not* supported.

### with postmarketOS

Install .apk files from selected release.

> [!CAUTION]
> postmarketOS builds are NOT devel-aware
> and *will* corrupt your tdata.
> Running those without backing up tdata
> is *not* supported.

### 64Gram-based

> [!CAUTION]
>
> Versions of Yukigram up to (and including) 6.4.1.1
> are deprecated and should no longer be used.
> They were based on 64Gram
> and developed in a downstream merge-based workflow.

"Enhanced settings" from 64Gram and Yukigram
are converted to native "Experimental settings" (in Advanced).
Users of past Yukigram should make a note of their enhanced settings
and toggle them on new versions,
because of different settings backends.

Past versions can be found at [yukigram-legacy] repo.

[yukigram-legacy]: https://github.com/yukigram/yukigram-legacy

## On AI

Telegram Desktop developers are using AI-generated code
and are adding a bunch of useless AI features.
Yukigram has no intention of completely ripping out
AI code from Telegram Desktop sources,
or has no intention of diverging codebases.
Therefore, it is clear that patch developers and maintainers
will definitely have some AI code exposure.

Most of the initial patches were written by me
by looking at surrounding 64Gram code
from times before the so-called vibe coding was popular.
Other patches were taken from forks
that developed them years ago.

I want to make this project
at least somewhat clear from AI code,
so please refrain from sending AI-assisted code here.

**This project is proudly made by real humans.**

Thank you for not wasting my time.
