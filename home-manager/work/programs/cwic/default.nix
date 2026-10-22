# cwic — CoreWeave Intelligent CLI (clusters, SUNK, object storage, registry).
# Not in nixpkgs, so we package the upstream pre-built release: a static Go
# binary, no patching needed. Its built-in auto-update can't write to the nix
# store; bump `version` + `hash` here instead. Work-only, so it gates itself on
# the custom.work.enable flag defined in ../../default.nix.
# Releases: https://github.com/coreweave/cwic/releases
{ config, lib, pkgs, ... }:

let
  cwic = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "cwic";
    version = "1.46.0";
    src = pkgs.fetchurl {
      url = "https://github.com/coreweave/cwic/releases/download/v${version}/cwic_Linux_x86_64.tar.gz";
      hash = "sha256-WHroOE1iUHf+n03Emvp2gd8lv3BAv0TTFSBdrhoMrOc=";
    };
    sourceRoot = ".";
    installPhase = ''
      install -Dm755 cwic $out/bin/cwic
    '';
    meta.platforms = [ "x86_64-linux" ];
  };
in
{
  config = lib.mkIf config.custom.work.enable {
    home.packages = [ cwic ];
  };
}
