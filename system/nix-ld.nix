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
  ];
}
