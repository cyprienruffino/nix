# Work-specific home-manager config. Opt-in, mirroring the system-level
# work module: nothing here applies unless `custom.work.enable = true`, which
# the `cyprien@nixos-work` flake output sets. A plain `cyprien@nixos` build
# leaves it off.
#
# This directory is auto-imported by home.nix, which is what registers the
# option below. It mirrors the top-level home-manager/ layout (packages.nix +
# packages/), and each leaf module gates its own config on the flag with `mkIf`.
{ config, lib, ... }:

{
  options.custom.work.enable =
    lib.mkEnableOption "work-specific home-manager configuration";

  imports =  # Import every subdirectory and every sibling .nix file
    let
      isModule = name: type:
        type == "directory"
        || (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix");
    in map (name: ./. + "/${name}")
       (builtins.attrNames (lib.filterAttrs isModule (builtins.readDir ./.)));
}
