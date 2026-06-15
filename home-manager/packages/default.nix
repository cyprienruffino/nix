{ pkgs, lib, ... }:

{
  imports =  # Import everything ffrom every subdirectories
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
    killall

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

    # Audio / Music
    guitarix
    qpwgraph
    ardour

    # Apps
    claude-code
    discord
    gimp
    obsidian
    freetube
    ferdium
    kdePackages.kate
  ];
}
