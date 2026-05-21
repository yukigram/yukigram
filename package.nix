{
  lib,
  stdenv,
  telegram-desktop,
  gst_all_1,
}:
telegram-desktop.overrideAttrs (final: prev: {
  pname = "yukigram";
  unwrapped = prev.unwrapped.overrideAttrs (final: prev: {
    pname = "yukigram-unwrapped";
    version = "6.8.3.1";
    src = prev.src.overrideAttrs {
      rev = "v6.8.3";
      hash = "sha256-01PByyAPWVz14IvwJP/qxc4fdiyH4EYLbIvpFY2GITU=";
    };
    cmakeFlags = prev.cmakeFlags ++ [
      (lib.cmakeBool "DEVEL" true)
    ];
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
