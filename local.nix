import ./. {
  appId = "io.github.yukigram.devel";
  customNixpakConfig = {pkgs, ...}: {
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
        (stdenv.mkDerivation {
          name = "yukigram-dev";
          src = ../yukigram-worktree/out/Debug/yukigram;
          dontUnpack = true;
          dontStrip = true;
          dontFixup = true;
          installPhase = ''
            mkdir -p $out/bin
            ln -s $src $out/bin/yukigram
          '';
        })
      ];
      executableName = "yukigram";
      runScript = "yukigram";
    });
  };
}
