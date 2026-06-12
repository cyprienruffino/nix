{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    btop
    htop
    micro
    yazi
    k9s

    # Media
    vlc
    mpv

    # Apps
    discord
    obsidian
    freetube
    ferdium
    ulauncher
  ];
}
