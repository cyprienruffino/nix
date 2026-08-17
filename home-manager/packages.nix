{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Archives
    bzip2
    gzip
    unrar
    unzip
    zip
    xz
    ncompress
    p7zip
    binutils
    zstd

    # CLI tools
    btop
    htop
    yazi
    wget
    screenfetch
    killall
    gh
    android-tools

    # Media / Audio / Music
    vlc
    guitarix
    qpwgraph
    ffmpeg
    ardour
    audacity
    # tuxguitar lives in programs/tuxguitar/ — it needs a dark-theme wrapper

    # Apps
    claude-code
    discord
    slack
    gimp
    obsidian
    freetube
    ferdium
    proton-vpn
    kdePackages.kate
  ];
}
