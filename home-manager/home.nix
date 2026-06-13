{ lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "cyprien";
  home.homeDirectory = "/home/cyprien";
  home.stateVersion = "26.05";

  imports =
    let dirs = builtins.readDir ./.;
    in map (name: ./. + "/${name}")
       (builtins.attrNames (lib.filterAttrs (_: t: t == "directory") dirs));

  home.file = lib.mapAttrs'
    (name: _: lib.nameValuePair ".local/res/${name}" { source = ../res + "/${name}"; })
    (lib.filterAttrs (_: t: t == "regular") (builtins.readDir ../res));

  programs.home-manager.enable = true;
}
