let
  path = toString ../yukigram-worktree/out/Debug;
  customNixpakConfig = {pkgs, ...}: {
    bubblewrap.bind.ro = [path];
    app.package = with pkgs;
      lib.mkForce (buildFHSEnv {
        name = "yukigram-dev-env";
        targetPkgs = p:
          with p; [
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
            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
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
        runScript = path + "/io.github.yukigram.devel";
      });
  };
  d = import ./. {};
  o = prev: {
    nixpak.yukigram = prev.nixpak.yukigram.override {
      appId = "io.github.yukigram.devel";
      inherit customNixpakConfig;
    };
  };
  d' = d.override o;
in
  d'.packages.nixpak
