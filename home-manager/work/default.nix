# Work-specific home-manager config. Opt-in, mirroring the system-level
# work module: nothing here applies unless `custom.work.enable = true`, which
# the `cyprien@nixos-work` flake output sets. A plain `cyprien@nixos` build
# leaves it off.
#
# This directory is auto-imported by home.nix, which is what registers the
# option below; `mkIf` is what keeps the body inert when the flag is off.
{ config, lib, pkgs, ... }:

{
  options.custom.work.enable =
    lib.mkEnableOption "work-specific home-manager configuration";

  config = lib.mkIf config.custom.work.enable {
    # Add work-only packages, programs and dotfiles here, e.g.:
    home.packages = with pkgs; [
      awscli2
      google-cloud-sdk
      terraform
      docker
      nodejs
      packer
    ];
  };
}
