# Features (patch descriptions)

- :zap:: Patches unique to Yukigram among all clients.
- :star:: Patches unique to Yukigram among current desktop clients.
- :gear:: Patches that add gated functionality, i.e. need to be enabled in runtime.

Patches listed by category,
not by their numerical order.
I have no idea how to "stably" link
to a filename with changing part,
and writing a full patch name
seems ridiculous.

## Structural patches

These patches have no category attached to them,
and other patches may not apply cleanly
(or not apply at all)
without them.

- Yukigram build support
- Yukigram branding
- Yukigram options framework
- Yukigram settings page
- Yukigram settings deeplinks
    (`tg://settings/yukigram/...`)
- Mirror select Experimental settings to Yukigram settings page

## Fixes of various bugs

These patches have category `Fix`
and generally are fixes for broken behaviour of various kinds.

- Disable D-Bus activation
    (unbreak `.desktop` launching under non-GNOME)
- Allow using symbolic (monochrome) tray icon from icon theme
    instead of bundled one with Yukigram name.
- Support `$XDG_DATA_HOME/Yukigram` as a fallback data directory for Yukigram
    (current one is `$XDG_DATA_HOME/io.github.yukigram`,
    or with `.devel` appended for development builds)

## Annoyances

This is what I mean by "minus the bullshit"

- No sponsored messages and channels
- No copy restrictions
    (forward restrictions are still in place)
- :star: Use [OpenStreetMap] instead of Google Maps when opening a location
- :zap: Disable registering url schemes
    and remove litter in `~/.local/share/applications`
- Disable AI message summaries
- Disable AI compose button by default
- Unshare phone number by default when adding contact
- Send large photos by default
- :zap: Disable AI Instant View summaries

[OpenStreetMap]: https://openstreetmap.org

## Features

I know this list is already called "features",
but these are more or less The Features,
i.e. they add shortcuts
or something that could not have been done before.

- tg://nya link support
- Immediate restart button
- :zap: :gear: Control calls with MPRIS
    (play/pause/play-pause: accept, next/prev/stop: decline/hangup)
- Allow more than 3/6 accounts
- tg://openmessage and tg://user links support
- Show sticker/emoji pack owner
- Shortcuts for forward (Alt+F), copy (Alt+C) and copy media only (Alt+Shift+C)
- Show channel/group member join date
- Clickable links in user bio
- :zap: Hide "similar channels" section on channel join message by default
    (it can still be toggled by clicking on join message itself)
- Hide "Join group" bottom button
    when it is possible to send messages without joining
    (e.g. in linked discussion groups)
- :zap: Always show edit timer
- :star: Allow opening group from peer info
- Show mutual contacts
- Show media DC
- :zap: Show more details in Active Sessions list
    (API ID, is unofficial client, session login date)
- :zap: Additional emoji aliases
    (`:docker:` -> :whale:,
    `:podman:` -> :whale2:,
    `:bottom:` -> :pleading_face:)

## User interface

A catch-all group for everything.
Most of these are opinionated and optional,
and Telegram Desktop defaults are keeped wherever possible.

- :gear: Disable animated emoji (animoji)
- :zap: :gear: Move post comments button to the right (more compact)
- :star: :gear: Single-column mobile-like layout
- :gear: Wide messages
- :gear: Always show "scheduled messages" button
- "Search messages from" button in more context menus
- Show time on service messages
- :gear: Show time with seconds
- Quick recent actions button
- Quick admin list button
- :gear: Show message id
- Increase maxSignatureSize to accomodate time with seconds and message id
- Larger stickers and round video messages
- :gear: Bot/chat/channel/forum/deleted icon near username in chat list
- :zap: "Has unofficial client" icon near username in chat list
- Show date of forwarded messages without hover
- :star: :gear: Hide per-chat wallpaper and use wallpaper from theme instead
- :zap: :gear: Collapsed chats in dialogs view (as in Kotatogram)
- :zap: :gear: Hide "Send As" channels that require Premium to use
- :zap: :gear: Hide "Send As" button completely
- :zap: Channel statistics button in kebab menu
    near quick Recent Actions button
- :zap: :gear: Hide reply backround emoji
- Move peer ID and join date in chat info from About to separate subsections
- :gear: Show inferred peer DC
- :zap: :gear: Hide Star reaction button when no stars are sent
- :zap: :gear: Hide Star reaction count completely
- :gear: Hide message bubble tail
- :star: :gear: Use system emoji font
    (from `emoji` font as defined by fontconfig)
    instead of bundled emoji packs
- :gear: Custom monospace font
- :gear: Hide popular stickers in suggested stickers
    (suggest only from installed packs)
- :gear: Hide popular animated emoji packs from picker
    (show only installed packs in picker)
- New Supergroup button

Some patches originate from [64Gram], [Forkgram] and [Kotatogram].

[64Gram]: https://github.com/TDesktop-x64/tdesktop
[Forkgram]: https://github.com/forkgram/tdesktop
[Kotatogram]: https://github.com/kotatogram/kotatogram-desktop

## Missing features

This is mostly a wishlist of sorts.
I have not yet implemented them,
and may never will.
To avoid duplicating work,
please tell me if you're going
to implement any of these.

Contributions welcome!

- Inline diff in Recent Actions
- Ban button for join requests
- Client-side user muting (as in 64Gram)
    or AyuGram-style Filters
- Ability to change font size
- Old-style spoilers
    (solid color, as in Telegram X)
- Compile-time option to use QtWebEngine for Instant View
