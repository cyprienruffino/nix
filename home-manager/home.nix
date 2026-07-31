{ lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "cyprien";
  home.homeDirectory = "/home/cyprien";
  home.stateVersion = "26.05";

  # Auto-import every sibling module: subdirectories (via their default.nix)
  # and plain .nix files, so flat modules like packages.nix don't need a
  # directory of their own.
  imports =
    let
      isModule = name: type:
        type == "directory"
        || (type == "regular" && lib.hasSuffix ".nix" name && name != "home.nix");
    in map (name: ./. + "/${name}")
       (builtins.attrNames (lib.filterAttrs isModule (builtins.readDir ./.)));

  home.file = lib.mapAttrs'
    (name: _: lib.nameValuePair ".local/res/${name}" { source = ../res + "/${name}"; })
    (lib.filterAttrs (_: t: t == "regular") (builtins.readDir ../res));

  programs.home-manager.enable = true;
}
