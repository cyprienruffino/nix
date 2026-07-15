{ pkgs, lib, ... }:

{
  imports =  # Import everything ffrom every subdirectories
    let dirs = builtins.readDir ./.;
    in map (name: ./. + "/${name}")
       (builtins.attrNames (lib.filterAttrs (_: t: t == "directory") dirs));

  home.packages = with pkgs; [
    # Archives
    bzip2
    gzip
    unrar
    unzip
    ncompress
    p7zip
    binutils
    zstd

    # CLI tools
    btop
    htop
    yazi
    wget
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
    android-tools


    # Media / Audio / Music
    vlc
    guitarix
    qpwgraph
    ffmpeg
    ardour
    audacity
    (tuxguitar.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        wrapProgram $out/bin/tuxguitar \
          --set GTK_THEME Adwaita:light
      '';
    }))

    # Apps
    claude-code
    discord
    gimp
    obsidian
    freetube
    ferdium
    proton-vpn
    kdePackages.kate
  ];
}
