# Compatibility layer for pip-installed native binaries (no /lib on NixOS).
{ pkgs, lib, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc  # libstdc++.so.6
    zlib          # libz.so.1
    glib          # libglib-2.0.so.0
    libGL         # libGL.so.1  (opencv)
    ffmpeg_7.lib  # libavcodec.so.61 and friends (ffmpeg 7.1)
    (lib.getLib cudaPackages_13.libnpp)  # libnppicc.so.13 etc. (torchcodec)

    # Tern (Stencil Labs terminal) dlopens these at runtime.
    libxcb         # libxcb.so.1
    libxkbcommon   # libxkbcommon{,-x11}.so.0
    wayland        # libwayland-{client,egl}.so
    vulkan-loader  # libvulkan.so.1  (EGL/GLES come from libGL above)
    libpulseaudio  # libpulse-simple.so.0
    linux-pam      # libpam.so.0
  ];
}
