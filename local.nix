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
      ];
      executableName = "yukigram";
      runScript = path + "/yukigram";
    });
  };
}
