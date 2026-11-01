{ pkgs, pkgsUnstable, ... }:

{
  home.packages = [
    # Stable's claude-code lags behind releases; track unstable for it.
    pkgsUnstable.claude-code
  ] ++ (with pkgs; [
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
    htop
    wget
    screenfetch
    jq
    yq
    killall
    gh
    android-tools
    uv
    ruff
    ty
    openssl

    # Media / Audio / Music
    vlc
    guitarix
    qpwgraph
    ffmpeg
    ardour
    audacity
    # tuxguitar lives in packages/tuxguitar/ — it needs a dark-theme wrapper

    # Apps
    discord
    signal-desktop
    chromium
    gimp
    obsidian
    freetube
    ferdium
    proton-vpn
    kdePackages.kate
  ]);
}
