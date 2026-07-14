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

Other patches may not apply cleanly
(or not apply at all)
without these.

- Build support
- Application ID
- Keywords for `.desktop` file
- Artwork
- Translations framework (from Kotatogram)
- Metadata (internal names, links, etc.)
- Branding (user-facing names)
- Version
- Options framework
- Yukigram settings page
- Deeplinks for Yukigram settings
    (`tg://settings/yukigram/...`)
- Experimental settings mirror at Yukigram settings
- Changelog

These are placed under `(Yukigram)` category.

## Fixes of various bugs

- Disable D-Bus activation
    (unbreak `.desktop` launching under non-GNOME)
- More appstream changelog versions (25 instead of 10),
    better version parsing
- Support `$XDG_DATA_HOME/Yukigram` as a fallback data directory for Yukigram
    (current one is `$XDG_DATA_HOME/io.github.yukigram`,
    or with `.devel` appended for development builds)
- Disable `~/.TelegramDesktop` tdata fallback
- Allow opening channel direct messages from kebab menus
    even if user is not an admin
- Always use bundled TooManyCooks
    (same situation as with libada,
    no distro packages it yet,
    and breaking bulids is not fun)
- Scale sticker/GIF preview to fit the window
- Workaround for `QGuiApplication::setBadgeNumber`
    (it uses `QCoreApplication::applicationName` without escaping
    and makes resulting D-Bus object path invalid
    if application name contains forbidden characters, e.g. dots)

[tdesktop#30840]: https://github.com/telegramdesktop/tdesktop/issues/30840

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
- tg://nya and tg://woof link support
- Allow more than 3/6 accounts
- :zap: Additional emoji aliases
    (`:docker:` -> :whale:,
    `:podman:` -> :whale2:,
    `:bottom:` -> :pleading_face:)
- :star: "Apply" instead of "Join" in peer info buttons

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
- :star: Chat types in some in peer list boxes
- :star: More info in folder chat list
- :zap: Warn when polls forbid revoting
- :star: Show deleted reply ID

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
- Plain send in context menu
- Mention by name with right-click
    (in addition to Ctrl + left-click from upstream)

These are placed under `(Shortcut)` category.

## System
- Allow using symbolic (monochrome) tray icon from icon theme
    instead of bundled one with Yukigram name.
- :zap: :gear: Control calls with MPRIS
    (play/pause/play-pause: accept,
    next/prev/stop: decline/hangup)

These are placed under `(System)` category.

## Major
- tg://openmessage and tg://user links support
- New Supergroup button
- Mention users by id
    (When creating a new link,
    e.g. with Ctrl+K on a selection,
    supply `tg://user?id=<user-id>` link
    or the bare id itself
    to create a mention)
- Split "Stickers and GIFs" chat permission toggle
- :star: Retract quiz vote
    (if quiz was created with "allow revotes")

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
- Video controls for GIFs
- :zap: :gear: Disable SHOUTING CASE on buttons
- Show custom title in group call bar
- :zap: :gear: Prevent chat history deletion

These are placed under `(Interface)` category.

## Chat
- "Search messages from" button in more context menus
- Show time on service messages
- :gear: Quick recent actions button
- :gear: Quick admin list button
- :zap: Channel statistics button in kebab menu
    near quick Recent Actions button
- Go to first message button
- :gear: Disable edit by Up key
- :star: :gear: Hide bottom button bar
    (Join channel, mute/unmute, etc)

These are placed under `(Chat)` category.

## Style
- :gear: Wide messages
- Increase maxSignatureSize to accomodate time with seconds and message id
- :star: :gear: Hide per-chat wallpaper and use wallpaper from theme instead
- :zap: :gear: Hide reply backround emoji
- :gear: Hide message bubble tail
- :star: Revert pill design for chat list suggestions
    (someone logged on, set birthday, buy premium, etc.)
- :zap: :gear: Old-style spoilers
    (solid color, as in Telegram X)
- Revert button rounding in history top bar
    (Forward, Delete, Send now)
- Revert button rounding in bot keyboard
- :star: :gear: Large sticker size in preview
- Constrain round messages width
    (don't push "Forwarded from" outside the screen on small screen widths)
- :star: :gear: Square round messages
- :gear: Change sticker size
    (:star: up to full size)
- :zap: :gear: Change animoji and custom emoji size
    (up to full size)
- :zap: :gear: Change round video messages size
    (up to full size)
- :star: Revert liquid glass peer tab strip

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
- :star: :gear: Replace preview links
    (e.g. `bsky.app` to `fxbsky.app`)

These are placed under `(Compose)` category.

## Translations
- English
- Russian

These are placed under `(Translations)` category.

Some patches originate from [64Gram], [Forkgram] and [Kotatogram].

[64Gram]: https://github.com/TDesktop-x64/tdesktop
[Forkgram]: https://github.com/forkgram/tdesktop
[Kotatogram]: https://github.com/kotatogram/kotatogram-desktop

# Missing features

This is mostly a wishlist of sorts.
I have not yet implemented them,
and may never will.
To avoid duplicating work,
please tell me if you're going
to implement any of these.

Contributions welcome!

- View poll results before voting (if poll allows)
- Inline diff in Recent Actions
- Ban button for join requests
- Client-side user muting (as in 64Gram)
    or AyuGram-style Filters

# Known bugs

- "Has unofficial client" icon won't show unless the user profile has already been opened before
- Autostart with nixpak does not work correctly as xdg-desktop-portal adds `flatpak run` to command
- "UTC+00:00:01" instead of readable timezone name ([nixpak#205])
- "Telegram is working in Screen Reader mode" even without screen reader ([tdesktop#30511])

[nixpak#205]: https://github.com/nixpak/nixpak/issues/205
[tdesktop#30511]: https://github.com/telegramdesktop/tdesktop/issues/30511
