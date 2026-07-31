{ lib, ... }:

{
  imports =  # Import everything from every subdirectory
    let dirs = builtins.readDir ./.;
    in map (name: ./. + "/${name}")
       (builtins.attrNames (lib.filterAttrs (_: t: t == "directory") dirs));
}
