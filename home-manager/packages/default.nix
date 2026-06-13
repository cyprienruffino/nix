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
    screenfetch
    stu

    # Cloud CLIs
    awscli2
    azure-cli
    google-cloud-sdk

    # Dev
    terraform
    docker
    nodejs
    packer
    gh


    # Media
    vlc
    mpv

    # Apps
    claude-code
    discord
    obsidian
    freetube
    ferdium
    kdePackages.kate
  ];
}
