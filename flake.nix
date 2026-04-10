{
  nixConfig = {
    extra-substituters = ["https://yukigram.github.io/yukigram"];
    extra-trusted-public-keys = ["yukigram-nixos-binary-cache:JY9MpP2ESUmPx3cfIpcSRpBK9HQ1/mzHemsvjv1aiYU="];
  };
  outputs = {...}: let
    makeOverridable = func: defargs:
      (func defargs)
      // {
        override = args: makeOverridable func (defargs // args);
      };
    default-nix = makeOverridable (import ./.);
  in {
    packages.x86_64-linux.default = default-nix {system = "x86_64-linux";};
    packages.aarch64-linux.default = default-nix {system = "aarch64-linux";};
  };
}
