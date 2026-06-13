{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "cyprien";
  home.homeDirectory = "/home/cyprien";
  home.stateVersion = "26.05";

  imports = [
    ./shell
    ./git
    ./kate
    ./kitty
    ./tmux
    ./packages
    ./plasma
    ./rofi
    ./python
    ./scripts
    ./vscode
  ];

  home.packages = with pkgs; [
    pkgs.claude-code
  ];

  home.file.".local/res/alarm.mp4".source = ../res/alarm.mp4;

  programs.home-manager.enable = true;
}
