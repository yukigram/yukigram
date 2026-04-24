{
  lib,
  telegram-desktop,
}:
telegram-desktop.override {
  pname = "yukigram";
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (final: prev: {
    name = "yukigram-unwrapped";
    version = "6.7.8";
    src = prev.src.overrideAttrs {
      tag = null;
      rev = "6e90f6876e2a2daf04d97ea97345cc9ad8ade378";
      hash = "sha256-lcIkkr9i/zVRNNQ3qi6O6xIgtpQgkVWOGIttHqmAQv8=";
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
