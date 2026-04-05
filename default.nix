{
  sources ? import ./npins,
  system ? builtins.currentSystem,
  nixpkgs ? sources.nixpkgs,
  pkgs ? import nixpkgs {inherit system;},
  nixpak ? import sources.nixpak,
  lib ? pkgs.lib,
  mkNixPak ? config: nixpak.lib.nixpak {inherit lib pkgs;} {inherit config;},
  appId ? "io.github.yukirgam",
  customNixpakConfig ? {},
}:
(mkNixPak {
  imports = [
    nixpak.profiles.gui-base
    nixpak.profiles.mpris2-player
    nixpak.profiles.network
    customNixpakConfig
  ];
  app.package = pkgs.callPackage ./package.nix {};
  flatpak.appId = appId;
  dbus.policies = {
    # https://github.com/flathub/org.telegram.desktop/commit/c647652ce6ed0dc6a89490f0c811371da8eb42f8
    "org.freedesktop.Notifications" = "talk";
    "org.kde.StatusNotifierWatcher" = "talk";
    "com.canonical.AppMenu.Registrar" = "talk";
    "com.canonical.indicator.application" = "talk";
    "org.ayatana.indicator.application" = "talk";
  };
}).config.env
