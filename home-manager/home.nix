{ config, pkgs, ... }:

{
  home.username = "cyprien";
  home.homeDirectory = "/home/cyprien";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # Add user packages here
  ];

  programs.home-manager.enable = true;
}
