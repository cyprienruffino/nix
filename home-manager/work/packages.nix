# Work-only packages, mirroring home-manager/packages.nix: a flat list of
# plain package names. Anything needing more than a name gets its own module
# under programs/. Gated on custom.work.enable like every work module.
{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.custom.work.enable {
    home.packages = with pkgs; [
      awscli2
      google-cloud-sdk
      terraform
      nodejs
      packer
      k9s
      stu
    ];
  };
}
