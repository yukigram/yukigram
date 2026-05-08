{
  lib,
  stdenv,
  telegram-desktop,
}:
(telegram-desktop.override {
  pname = "yukigram";
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (final: prev: {
    name = "yukigram-unwrapped";
    version = "6.8.1";
    src = prev.src.overrideAttrs {
      hash = "sha256-CcibFBPbviakOsf+BpAF8U0CRWIt3zO/KiHycwRw2V0=";
    };
    patches = let
      readDir' = d: lib.pipe d [builtins.readDir builtins.attrNames (map (lib.path.append d))];
    in
      (prev.patches or []) ++ (readDir' ./tdesktop/cur);
    meta = {
      description = "Telegram Desktop, minus the bullshit, plus the features";
      homepage = "https://github.com/yukigram/yukigram";
      mainProgram = "yukigram";
    };
  });
}).overrideAttrs (final: prev: {
  # Disable substitution in `share/dbus-1/services/` as there is no absolute path now
  postFixup =
    if stdenv.hostPlatform.isLinux
    then ""
    else prev.postFixup;
})
