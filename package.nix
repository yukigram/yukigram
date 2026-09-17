{
  lib,
  stdenv,
  telegram-desktop,
  cmark-gfm,
  gst_all_1,
  pango,
  cairo,
  tlottie,
}:
telegram-desktop.overrideAttrs (final: prev: {
  pname = "yukigram";
  unwrapped = prev.unwrapped.overrideAttrs (final: prev: {
    pname = "yukigram-unwrapped";
    version = "7.2.8.0-rc.1";
    src = prev.src.overrideAttrs {
      rev = "v7.2.8";
      hash = "sha256-Hhx65dqKlsoLvh7lEWYxnIiXFFd0qrDKpYYsHdhzqnk=";
    };
    cmakeFlags =
      prev.cmakeFlags
      ++ [
        (lib.cmakeBool "DEVEL" true)
      ];
    patches = let
      readDir' = d: lib.pipe d [builtins.readDir builtins.attrNames (map (lib.path.append d))];
    in
      (prev.patches or []) ++ (readDir' ./tdesktop/cur);
    meta = {
      description = "Telegram Desktop, minus the bullshit, plus the features";
      homepage = "https://github.com/yukigram/yukigram";
      changelog = "https://github.com/yukigram/yukigram/releases";
      mainProgram = "io.github.yukigram.devel";
    };
    # 7.2 requires pango?
    buildInputs = [pango cairo tlottie] ++ prev.buildInputs;
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
