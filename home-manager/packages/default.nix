{ pkgs, lib, ... }:

{
  imports =
    let dirs = builtins.readDir ./.;
    in map (name: ./. + "/${name}")
       (builtins.attrNames (lib.filterAttrs (_: t: t == "directory") dirs));

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
    steam
    kdePackages.kate
  ];
}
