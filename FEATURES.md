# Features (patch descriptions)

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
1. (Annoyances) Send large photos by default
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
1. (Feature) Show mutual contacts
1. (Feature) Show media DC
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
1. (UI, optional) Show inferred peer DC
1. (UI, optional) Hide Star reaction button when no stars are sent
1. (UI, optional) Hide Star reaction count completely
1. (UI, optional) Hide message bubble tail

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
