import ./. {
  appId = "io.github.yukigram.devel";
  customNixpakConfig = let
    path = toString ../yukigram-worktree/out/Debug;
  in {pkgs, ...}: {
    bubblewrap.bind.ro = [path];
    app.package = with pkgs; lib.mkForce (buildFHSEnv {
      name = "yukigram-dev-env";
      targetPkgs = p: with p; [
        libgcc
        fontconfig
        freetype
        glib
        libX11
        wayland
        mesa
        gtk3
        libxkbcommon
        xkeyboard-config
        libGL
        webkitgtk_4_1
        dbus
        kdePackages.breeze-icons
        (stdenv.mkDerivation {
          name = "yukigram-data";
          src = ../yukigram-worktree/app/share;
          dontUnpack = true;
          installPhase = ''
            mkdir -p $out/share
            cp -r $src/. $out/share/
          '';
        })
      ];
      executableName = "yukigram";
      runScript = path + "/yukigram";
    });
  };
}
