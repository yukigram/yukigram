# Yukigram

Telegram Desktop, minus the bullshit, plus the features.

## Features (patch descriptions)

<!-- Note:
keep this list consistent with files in tdesktop/cur/
use `1.` as list marker to make diffs shorter in case of drops or reorders
-->
1. Yukigram branding
1. Yukigram build support
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
1. Option to use wide messages
1. Allow more than 3/6 accounts
1. Option to always show "scheduled messages" button
1. tg://openmessage and tg://user links support
1. Disable AI long message summary button
1. "Search messages from" button in more context menus
1. Show time with seconds
1. Show sticker/emoji pack owner
1. Quick recent actions button
1. Quick admin list button
1. Disable registering url schemes and remove litter in `~/.local/share/applications`
1. Option to show message id
1. Increase maxSignatureSize to accomodate time with seconds and message id
1. Larger stickers and round video messages
1. Shortcuts for forward (Alt+F), copy (Alt+C) and copy media only (Alt+Shift+C)
    (only works if "select recepient" is used, not "open chat with settings")
1. Disable AI compose button by default
1. Disable D-Bus activation (unbreak `.desktop` launching under non-GNOME)
1. Show channel/group member join date
1. Unshare phone number by default when adding contact
1. Clickable links in user bio
1. Bot/chat/channel/forum/deleted icon near username in chat list
1. "Has unofficial client" icon near username in chat list
1. Hide "similar channels" section on channel join message by default
    (it can still be toggled by clicking on join message itself)
1. Show date of forwarded messages without hover
1. Hide "Join group" bottom button when it is possible to send messages without joining
    (e.g. in linked discussion groups)
1. Always show edit timer
1. Option to hide per-chat wallpaper and use wallpaper from theme instead
1. Allow opening group from peer info

Some patches originate from [64Gram], [Forkgram] and [Kotatogram].

[OpenStreetMap]: https://openstreetmap.org
[64Gram]: https://github.com/TDesktop-x64/tdesktop
[Forkgram]: https://github.com/forkgram/tdesktop
[Kotatogram]: https://github.com/kotatogram/kotatogram-desktop

## Missing features

Contributions welcome!

- Separate settings group instead of Experimental settings
- Yukigram settings search support
- Ban button for join requests
- Client-side user muting (as in 64Gram)
- Disable Cocoon AI summary in Instant View
- Collapsed chats in dialogs view (as in Kotatogram)
- Ability to change font size
- Ability to change monospace font
    (or use one from xdg-desktop-portal-gtk)
    (probably requires submodule patching)
- Old-style spoilers
    (solid color, as in Telegram X)
    (requires submodule patching)
- Compile-time option to use QtWebEngine for Instant View
    (requires submodule patching)

[org.telegram.desktop.webview]: https://github.com/flathub/org.telegram.desktop.webview

## Known bugs

- "Has unofficial client" icon won't show unless the user profile has already been opened before
- "UTC+00:00:01" instead of readable timezone name ([nixpak#201])
- "Telegram is working in Screen Reader mode" even without screen reader ([tdesktop#30511])

[nixpak#201]: https://github.com/nixpak/nixpak/issues/205
[tdesktop#30511]: https://github.com/telegramdesktop/tdesktop/issues/30511

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

GitHub Actions workflows and flatpak manifest
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
