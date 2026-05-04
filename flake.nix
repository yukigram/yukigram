{
  nixConfig = {
    extra-substituters = [
      "https://yukigram-official.cachix.org"
      "https://yukigram.github.io/yukigram"
    ];
    extra-trusted-public-keys = [
      "yukigram-official.cachix.org-1:PmmKVD/46LWDxfPWKol4rvoqvcdLqFq0aTtG/E1gdA8="
      "yukigram-nixos-binary-cache:JY9MpP2ESUmPx3cfIpcSRpBK9HQ1/mzHemsvjv1aiYU="
    ];
  };
  outputs = {self, ...}: let
    genAttrs = ks: f: builtins.listToAttrs (map (name: {inherit name; value = f name;}) ks);
    d = genAttrs ["x86_64-linux" "aarch64-linux"] (system: import ./. {inherit system;});
  in {
    inherit d;
    packages = builtins.mapAttrs (_: d: d.packages) d;
  };
}
