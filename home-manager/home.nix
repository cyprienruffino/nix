{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "cyprien";
  home.homeDirectory = "/home/cyprien";
  home.stateVersion = "26.05";

  imports =
    let dirs = builtins.readDir ./.;
    in map (name: ./. + "/${name}")
       (builtins.attrNames (lib.filterAttrs (_: t: t == "directory") dirs));

  home.packages = with pkgs; [
    pkgs.claude-code
  ];

  home.file.".local/res/alarm.mp4".source = ../res/alarm.mp4;

  programs.home-manager.enable = true;
}
