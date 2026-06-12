{ config, pkgs, ... }:

{
  home.username = "cyprien";
  home.homeDirectory = "/home/cyprien";
  home.stateVersion = "26.05";

  imports = [
    ./shell
  ];

  home.packages = with pkgs; [
  ];

  programs.home-manager.enable = true;
}
