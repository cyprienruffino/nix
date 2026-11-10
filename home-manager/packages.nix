{ pkgs, pkgsUnstable, ... }:

{
  home.packages = [
    # Stable's claude-code lags behind releases; track unstable for it.
    # Its native binary dlopens X11/GPU/keyring libs that nixpkgs' wrapper
    # doesn't expose (panics: "failed to load libxcb").
    (pkgsUnstable.claude-code.overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        wrapProgram $out/bin/claude --suffix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath (with pkgs; [
          libxcb
          libx11
          libxkbcommon
          wayland
          vulkan-loader
          libGL
          libsecret
        ])}
      '';
    }))
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

    # Network debugging
    dnsutils    # dig, nslookup, host
    nettools    # netstat, ifconfig, route, arp
    nmap        # port scanning
    traceroute
    whois
    mtr         # combined traceroute + ping
    tcpdump     # packet capture
    iperf3      # bandwidth testing
    lsof        # list open files/sockets

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
