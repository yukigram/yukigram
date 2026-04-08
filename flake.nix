{
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
