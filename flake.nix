{
  nixConfig = {
    extra-substituters = [
      "https://yukigram-official.cachix.org"
      "https://yukigram.github.io/yukigram"
    ];
    extra-trusted-public-keys = ["yukigram-nixos-binary-cache:JY9MpP2ESUmPx3cfIpcSRpBK9HQ1/mzHemsvjv1aiYU="];
  };
  outputs = {self, ...}: let
    genAttrs = ks: f: builtins.zipAttrsWith (k: _: f k) (map (k: {${k} = 0;}) ks);
    d = genAttrs ["x86_64-linux" "aarch64-linux"] (system: import ./. {inherit system;});
  in {
    inherit d;
    packages = builtins.mapAttrs (_: d: d.packages) d;
  };
}
