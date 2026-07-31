# Work-only packages, mirroring home-manager/packages: a flat list of plain
# package names here, plus auto-imported subdirectories for packages that need
# more than just a name (e.g. zoom). Everything is gated on custom.work.enable.
{ config, lib, pkgs, ... }:

{
  imports =  # Import everything from every subdirectory
    let dirs = builtins.readDir ./.;
    in map (name: ./. + "/${name}")
       (builtins.attrNames (lib.filterAttrs (_: t: t == "directory") dirs));

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
