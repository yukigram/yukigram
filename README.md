# Yukigram

Telegram Desktop, minus the bullshit, plus the features.

## Features (patch descriptions)

<!-- Note:
keep this list consistent with files in tdesktop/cur/
use `1.` as list marker to make diffs shorter in case of drops or reorders
-->
1. Yukigram branding
1. tg://nya link support
1. No sponsored messages
1. Immediate restart button
1. Option for disabling animated emoji (animoji)
1. Support for moving post comments button to the right (more compact)
1. Option to control calls with MPRIS
    (play/pause/play-pause: accept, next/prev/stop: decline/hangup)
1. No copy restrictions (forward restrictions are still in place)
1. Option to force single-column mobile-like layout
1. Use [OpenStreetMap] instead of Google Maps when opening a location
1. Hide "similar channels" popup on "you joined this channel" message
1. Option to use wide messages
1. Allow more than 3/6 accounts
1. Option to always show "scheduled messages" button
1. tg://openmessage and tg://user links support
1. Disable AI long message summary button
1. "Show messages from user" button in context menu
1. Show time with seconds
1. Show sticker/emoji pack owner
1. Quick recent actions button
1. Quick admin list button
1. Disable registering url schemes and remove litter in `~/.local/share/applications`
1. Show message id
1. Increase maxSignatureSize to accomodate time with seconds and message id
1. Larger stickers and round video messages
1. Shortcuts for forward (Alt+F), copy (Alt+C) and copy media only (Alt+Shift+C)
    (only works if "select recepient" is used, not "open chat with settings")
1. Disable AI compose button by default
1. Disable D-Bus activation (unbreak `.desktop` launching under non-GNOME)

Some patches originate from [64Gram].

[OpenStreetMap]: https://openstreetmap.org
[64Gram]: https://github.com/TDesktop-x64/tdesktop

## Missing features

Contributions welcome!

- Client-side user muting (as in 64Gram)
- Disable Cocoon AI summary in Instant View
- Collapsed chats in dialogs view (as in Kotatogram)
- Ability to change font size
- Ability to change monospace font
    (probably requires submodule patching)
- Compile-time option to use QtWebEngine for Instant View
    (requires submodule patching)
- KDE Platform in flatpak manifest instead of building patched Qt
    (requires QtWebEngine or reincarnating [org.telegram.desktop.webview])

[org.telegram.desktop.webview]: https://github.com/flathub/org.telegram.desktop.webview

## Known bugs

- "Similar channels" disabling patch is broken
- "UTC+00:00:01" instead of readable timezone name ([nixpak#201])

[nixpak#201]: https://github.com/nixpak/nixpak/issues/205

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

Note that due to limitations of [`git am`][git-am]
and heavy use of submodules in upstream tdesktop,
it is currently not possible to patch submodules.
Support for such patching may be added in the future,
when it becomes essential.

[git-am]: https://git-scm.com/docs/git-am
[range-diff]: https://git-scm.com/docs/git-range-diff

## Installation

Do not blindly trust our binary caches.
They are built by GitHub Actions,
and are supposed to be reproducible, though.

Windows and macOS are *not* supported.

Consider using isolated packages
and reviewing and refining their permissions
(with e.g. [Flatseal] for flatpak
or by creating a custom [Nixpak])
instead of plain binaries.

### with flatpak

#### with binary caches

```shell
flatpak remote-add --user --if-not-exists yukigram https://yukigram.github.io/yukigram/index.flatpakrepo
flatpak install io.github.yukigram
```

#### manual build

```shell
git submodule update --init --recursive
cd flatpak/org.telegram.desktop
git apply ../0001-Yukigram.patch
flatpak-builder --ccache --force-clean build org.telegram.desktop.yml
```

### with nix

See [this page][nix-bincache] for details on how to set up binary caches.

[nix-bincache]: https://yukigram.github.io/yukigram

#### nixpak (locked nixpkgs)

without flakes:
```nix
import <yukigram> {}
```

with flakes:
```nix
yukigram.packages.${system}.default
```

#### nixpak (custom options)

without flakes:
```nix
import <yukigram> {
    nixpkgs = <nixpkgs>;
    # or
    pkgs = import <nixpkgs> {};

    customNixpakConfig = {
        sockets.pulse = false;
    };
}
```

with flakes:
```nix
yukigram.packages.${system}.default.override {
    nixpkgs = my-pinned-nixpkgs;
    # or
    pkgs = my-pkgs;

    customNixpakConfig = {
        sockets.pulse = false;
    };
}
```

#### non-isolated package

without flakes:
```nix
pkgs.callPackage <yukigram/package.nix> {}
```

### on PostmarketOS

Support planned.
In the meantime, use [Nix] or Flatpak.

### with other package manager

Check your package manager's manual on how to add patches to packages
and package Telegram Desktop (of correct version)
with your selection of patches.

[Flatseal]: https://github.com/tchx84/Flatseal
[Nixpak]: https://github.com/nixpak/nixpak
[Nix]: https://lix.systems

## Updating to newer versions

Patchset supports only one version out of the box.
This version is indicated in commit message and in tag name.
For updating patchset to newer versions, use

```shell
git clone https://github.com/telegramdesktop/tdesktop && cd tdesktop
TAG=v6.7.3 # Do not skip patch and pre-release versions
git checkout $TAG && git submodule update --recursive && git am -3 ../yukigram/tdesktop/
# fix am conflicts
git format-patch -o ../yukigram/tdesktop/cur $TAG && cd ../yukigram && git add . && git commit -m "$TAG: patches only"
```

If any patches were dropped, reordered, or added,
please change the list in the README accordingly.

Nix package update steps:
1. change version in `package.nix` and set hash to `lib.fakeHash`
2. fail a build once to get the correct hash
3. build again with `nix-build --argstr appId io.github.yukigram.devel`
4. test `./result/bin/yukigram`

Flatpak manifest update steps:
1. update submodule to newer version.
    If there is no newer version merged,
    create a patch updating tdesktop manually.
2. roundtrip the patch with `git am -3` and `git format-patch`
    to make sure it applies cleanly
3. (optionally) build with `flatpak-builder --ccache`

If both nix and flatpak packages are updated,
commit message can be changed to simply `$TAG`,
dropping "patches only".

Commits with "patches only" mark are *not* tested
and may contain bugs fixed in next commits.

A tag should be added when the version is sufficiently tested
and is generally ready to be used.

## Updating patchset

1. change title of about box to reflect new version
    in `Telegram/SourceFiles/boxes/about_box.cpp`
2. tag a new version with increased fourth component
    (v6.7.5 -> v6.7.5.1 -> v6.7.5.2)
3. push `main` branch, and then push corresponding tag

## Previous versions

Versions of Yukigram up to (and including) 6.4.1.1 are deprecated
and should no longer be used.
They were based on 64Gram and developed in a downstream merge-based workflow.

"Enhanced settings" from 64Gram and Yukigram
are converted to native "Experimental settings" (in Advanced).
Users of past Yukigram should make a note of their enhanced settings
and toggle them on new versions,
because of different settings backends.

Past versions can be found at [yukigram-legacy] repo.

[yukigram-legacy]: https://github.com/yukigram/yukigram-legacy

## Licensing

This project follows the [REUSE specification][reuse-spec].

Patches for Telegram Desktop (under `tdesktop/cur/`)
are provided under [GPL-3.0-only]
with [OpenSSL exception][sqlitestudio-OpenSSL-exception].

Patches for flatpak manifest (under `flatpak/`)
are provided under [MIT].

Nix package definitions
are provided under [CC0-1.0] or [Unlicense] at your option.

This file is licensed under [CC0-1.0].

See [`REUSE.toml`](./REUSE.toml) for some details.

Additionally, `.svg` files embedded inside patches in `tdesktop/cur/`, namely

- Telegram/Resources/art/yukigram.svg
- Telegram/Resources/icons/info/edit/group_manage_actions_topbar.svg
- Telegram/Resources/icons/info/edit/group_manage_admins_topbar.svg

are provided under [CC0-1.0].

[reuse-spec]: https://reuse.software/spec-3.3/
[GPL-3.0-only]: ./LICENSES/GPL-3.0-only.txt
[sqlitestudio-OpenSSL-exception]: ./LICENSES/LicenseRef-sqlitestudio-OpenSSL-exception.txt
[CC0-1.0]: ./LICENSES/CC0-1.0.txt
[Unlicense]: ./LICENSES/Unlicense.txt
[MIT]: ./LICENSES/MIT.txt
[`REUSE.toml`]: ./REUSE.toml
