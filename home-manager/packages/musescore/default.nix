{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      musescore = prev.musescore.overrideAttrs (old: rec {
        version = "4.4.4";
        src = prev.fetchFromGitHub {
          owner = "musescore";
          repo = "MuseScore";
          rev = "v${version}";
          hash = "sha256-/1kAgzmSbnuCqd6YxbaYW2+gE0Gvy373y5VfUK4OVzI=";
        };
      });
    })
  ];

  home.packages = [ pkgs.musescore ];
}
