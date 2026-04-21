{
  lib,
  telegram-desktop,
}:
telegram-desktop.override {
  pname = "yukigram";
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (final: prev: {
    name = "yukigram-unwrapped";
    version = "6.7.7";
    src = prev.src.overrideAttrs {
      hash = "sha256-uvVfzpb69tTHPZv1BICun6/Etumjdh3A8qLpMCAa/FM=";
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
}
