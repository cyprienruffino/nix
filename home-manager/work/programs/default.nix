{ lib, ... }:

{
  imports =  # Import every subdirectory and every sibling .nix file
    let
      isModule = name: type:
        type == "directory"
        || (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix");
    in map (name: ./. + "/${name}")
       (builtins.attrNames (lib.filterAttrs isModule (builtins.readDir ./.)));
}
