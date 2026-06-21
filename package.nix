{
  lib,
  stdenv,
  telegram-desktop,
  gst_all_1,
  minizip,
  zlib,
}:
telegram-desktop.overrideAttrs (final: prev: {
  pname = "yukigram";
  unwrapped = prev.unwrapped.overrideAttrs (final: prev: {
    pname = "yukigram-unwrapped";
    version = "6.9.3.2-rc.1+wip";
    src = prev.src.overrideAttrs {
      rev = "v6.9.3";
      hash = "sha256-QCGtESg+38lHWCFcsevHdc0kQ7LKJQmJjUJWszphah8=";
    };
    cmakeFlags = prev.cmakeFlags ++ [
      (lib.cmakeBool "DEVEL" true)
    ];
    # system minizip and zlib are required since 6.9.0
    buildInputs = (prev.buildInputs or []) ++ [minizip zlib];
    patches = let
      readDir' = d: lib.pipe d [builtins.readDir builtins.attrNames (map (lib.path.append d))];
    in
      (prev.patches or []) ++ (readDir' ./tdesktop/cur);
    meta = {
      description = "Telegram Desktop, minus the bullshit, plus the features";
      homepage = "https://github.com/yukigram/yukigram";
      changelog = "https://t.me/yukigram";
      mainProgram = "io.github.yukigram.devel";
    };
  });

  # webkitgtk requires gstreamer for audio support
  buildInputs =
    (prev.buildInputs or [])
    ++ [
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
    ];

  # Disable substitution in `share/dbus-1/services/` as there is no absolute path now
  postFixup =
    if stdenv.hostPlatform.isLinux
    then ""
    else prev.postFixup;
})
