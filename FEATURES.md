# Features (patch descriptions)

- :zap:: Patches unique to Yukigram among all clients.
- :star:: Patches unique to Yukigram among current desktop clients.
- :gear:: Patches that add gated functionality, i.e. need to be enabled in runtime.

Patches are sorted by category first,
then by an arbitrary subcategory,
and then by their numerical order.

To list patches in a category, use
```shell
printf "%s\n" tdesktop/cur/????-Category-*
```

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

- Disable D-Bus activation
    (unbreak `.desktop` launching under non-GNOME)
- Allow using symbolic (monochrome) tray icon from icon theme
    instead of bundled one with Yukigram name.
- Support `$XDG_DATA_HOME/Yukigram` as a fallback data directory for Yukigram
    (current one is `$XDG_DATA_HOME/io.github.yukigram`,
    or with `.devel` appended for development builds)

These are placed under `(Fix)` category.

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

These are placed under `(Annoyances)` category.

## Minor
- tg://nya link support
- Allow more than 3/6 accounts
- :zap: Additional emoji aliases
    (`:docker:` -> :whale:,
    `:podman:` -> :whale2:,
    `:bottom:` -> :pleading_face:)

These are placed under `(Minor)` category.

## Informative
- Show sticker/emoji pack owner
- Show channel/group member join date
- :zap: Always show edit timer
- Show mutual contacts
- Show media DC
- :zap: Show more details in Active Sessions list
    (API ID, is unofficial client, session login date)
- :gear: Show inferred peer DC

These are placed under `(Info)` category.

## Shortcuts
- Immediate restart button
- Shortcuts for forward (Alt+F), copy (Alt+C) and copy media only (Alt+Shift+C)
- Clickable links in user bio
- :zap: Hide "similar channels" section on channel join message by default
    (it can still be toggled by clicking on join message itself)
- Hide "Join group" bottom button
    when it is possible to send messages without joining
    (e.g. in linked discussion groups)
- :star: Allow opening group from peer info

These are placed under `(Shortcut)` category.

## Major
- :zap: :gear: Control calls with MPRIS
    (play/pause/play-pause: accept,
    next/prev/stop: decline/hangup)
- tg://openmessage and tg://user links support
- New Supergroup button
- Mention users by id
    (When creating a new link,
    e.g. with Ctrl+K on a selection,
    supply `tg://user?id=<user-id>` link
    or the bare id itself
    to create a mention)

These are placed under `(Major)` category.

## Interface
- :star: :gear: Single-column mobile-like layout
- :gear: Show time with seconds
- :zap: :gear: Collapsed chats in dialogs view
    (as in Kotatogram)
- Move peer ID and join date in chat info from About to separate subsections
- :star: :gear: Use system emoji font
    (from `emoji` font as defined by fontconfig)
    instead of bundled emoji packs
- :gear: Custom monospace font

These are placed under `(Interface)` category.

## Chat
- "Search messages from" button in more context menus
- Show time on service messages
- Quick recent actions button
- Quick admin list button
- :zap: Channel statistics button in kebab menu
    near quick Recent Actions button
- Go to first message button

These are placed under `(Chat)` category.

## Chat style
- :gear: Wide messages
- Increase maxSignatureSize to accomodate time with seconds and message id
- Larger stickers and round video messages
- :star: :gear: Hide per-chat wallpaper and use wallpaper from theme instead
- :zap: :gear: Hide reply backround emoji
- :gear: Hide message bubble tail

These are placed under `(Style)` category.

## Messages
- :gear: Disable animated emoji (animoji)
- :zap: :gear: Move post comments button to the right (more compact)
- :gear: Show message id
- :zap: :gear: Bot/chat/channel/forum/deleted icon near message sender display name in message history
- "Has unofficial client" icon near message sender display name in message history
- Show date of forwarded messages without hover

These are placed under `(Message)` category.

## Reactions
- :zap: :gear: Hide Star reaction button when no stars are sent
- :zap: :gear: Hide Star reaction count completely

These are placed under `(Reactions)` category.

## Composing messages
- :gear: Always show "scheduled messages" button
- :zap: :gear: Hide "Send As" channels that require Premium to use
- :zap: :gear: Hide "Send As" button completely
- :gear: Hide popular stickers in suggested stickers
    (suggest only from installed packs)
- :gear: Hide popular animated emoji packs from picker
    (show only installed packs in picker)

These are placed under `(Compose)` category.

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
