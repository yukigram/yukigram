# Yukigram

Telegram Desktop, minus the bullshit, plus the features.

## Features (patch descriptions)

<!-- Note:
keep this list consistent with files in tdesktop/cur/
use `1.` as list marker to make diffs shorter in case of drops or reorders
-->
1. Yukigram build support
1. Yukigram branding
1. Yukigram options framework
1. Yukigram settings page
1. Yukigram settings deeplinks
    (`tg://settings/yukigram/...`)
1. Mirror select Experimental settings to Yukigram settings page
1. (Fix) Disable D-Bus activation
    (unbreak `.desktop` launching under non-GNOME)
1. (Fix) Allow using symbolic (monochrome) tray icon from icon theme
    instead of bundled one with Yukigram name.
1. (Fix) Support `$XDG_DATA_HOME/Yukigram` as a fallback data directory for Yukigram
    (current one is `$XDG_DATA_HOME/io.github.yukigram`,
    or with `.devel` appended for development builds)
1. (Annoyances) No sponsored messages
1. (Annoyances) No copy restrictions
    (forward restrictions are still in place)
1. (Annoyances) Use [OpenStreetMap] instead of Google Maps when opening a location
1. (Annoyances) Disable registering url schemes
    and remove litter in `~/.local/share/applications`
1. (Annoyances) Disable AI message summaries
1. (Annoyances) Disable AI compose button by default
1. (Annoyances) Unshare phone number by default when adding contact
1. (Feature) tg://nya link support
1. (Feature) Immediate restart button
1. (Feature, optional) Control calls with MPRIS
    (play/pause/play-pause: accept, next/prev/stop: decline/hangup)
1. (Feature) Allow more than 3/6 accounts
1. (Feature) tg://openmessage and tg://user links support
1. (Feature) Show sticker/emoji pack owner
1. (Feature) Shortcuts for forward (Alt+F), copy (Alt+C) and copy media only (Alt+Shift+C)
    (only works if "select recepient" is used, not "open chat with settings")
1. (Feature) Show channel/group member join date
1. (Feature) Clickable links in user bio
1. (Feature) Hide "similar channels" section on channel join message by default
    (it can still be toggled by clicking on join message itself)
1. (Feature) Hide "Join group" bottom button
    when it is possible to send messages without joining
    (e.g. in linked discussion groups)
1. (Feature) Always show edit timer
1. (Feature) Allow opening group from peer info
1. (UI, optional) Disable animated emoji (animoji)
1. (UI, optional) Move post comments button to the right (more compact)
1. (UI, optional) Single-column mobile-like layout
1. (UI, optional) Wide messages
1. (UI, optional) Always show "scheduled messages" button
1. (UI) "Search messages from" button in more context menus
1. (UI) Show time on service messages
1. (UI, optional) Show time with seconds
1. (UI) Quick recent actions button
1. (UI) Quick admin list button
1. (UI, optional) Show message id
1. (UI) Increase maxSignatureSize to accomodate time with seconds and message id
1. (UI) Larger stickers and round video messages
1. (UI, optional) Bot/chat/channel/forum/deleted icon near username in chat list
1. (UI) "Has unofficial client" icon near username in chat list
1. (UI) Show date of forwarded messages without hover
1. (UI, optional) Hide per-chat wallpaper and use wallpaper from theme instead
1. (UI, optional) Collapsed chats in dialogs view (as in Kotatogram)
1. (UI, optional) Hide "Send As" channels that require Premium to use
1. (UI, optional) Hide "Send As" button completely
1. (UI) Channel statistics button in kebab menu
    near quick Recent Actions button
1. (UI, optional) Hide reply backround emoji
1. (UI) Move peer ID and join date in chat info from About to separate subsections

Some patches originate from [64Gram], [Forkgram] and [Kotatogram].

[OpenStreetMap]: https://openstreetmap.org
[64Gram]: https://github.com/TDesktop-x64/tdesktop
[Forkgram]: https://github.com/forkgram/tdesktop
[Kotatogram]: https://github.com/kotatogram/kotatogram-desktop

## Missing features

Contributions welcome!

- Ban button for join requests
- Client-side user muting (as in 64Gram)
- Disable Cocoon AI summary in Instant View
- Ability to change font size
- Ability to change monospace font
    (or use one from xdg-desktop-portal-gtk)
    (probably requires submodule patching)
- Old-style spoilers
    (solid color, as in Telegram X)
    (requires submodule patching)
- Compile-time option to use QtWebEngine for Instant View
    (requires submodule patching)

## Known bugs

- "Has unofficial client" icon won't show unless the user profile has already been opened before
- Autostart with nixpak does not work correctly as xdg-desktop-portal adds `flatpak run` to command
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

Some more information can be found in [`CONTRIBUTING.md`].

[git-am]: https://git-scm.com/docs/git-am
[range-diff]: https://git-scm.com/docs/git-range-diff
[`CONTRIBUTING.md`]: ./CONTRIBUTING.md

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
[custom Nixpak]: #nixpak-custom-options

### with flatpak

#### with binary caches

```shell
flatpak remote-add --user --if-not-exists yukigram https://yukigram.github.io/yukigram/index.flatpakrepo
sudo flatpak install io.github.yukigram
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

Custom nixpak options are required to launch Yukigram nixpak under X11.

without flakes:
```nix
import <yukigram> {
    nixpkgs = <nixpkgs>;
    # or
    pkgs = import <nixpkgs> {};

    customNixpakConfig = {
        bubblewrap.sockets.x11 = true;
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
        bubblewrap.sockets.x11 = true;
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
In the meantime, use [Nix](#with-nix) or [Flatpak](#with-flatpak).

### with other package manager

Check your package manager's manual
on how to add patches to packages
and package Telegram Desktop (of correct version)
with your selection of patches.

Unofficial packages that seem correct
and may be used instead of a manual from-source build:

- AUR package [`yukigram-desktop`][aur-yukigram]

[aur-yukigram]: https://aur.archlinux.org/packages/yukigram-desktop

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
