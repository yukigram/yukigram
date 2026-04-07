{
  lib,
  telegram-desktop,
}:
telegram-desktop.override {
  pname = "yukigram";
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (final: prev: {
    name = "yukigram-unwrapped";
    version = "6.7.5";
    src = prev.src.overrideAttrs {
      hash = "sha256-HsXNTZY/+Xz7pIT7durOd5T/u7jML0rVBOPb4pnIXow=";
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
