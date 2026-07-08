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
          hash = "sha256-0cjp1sp50pwmrgvpxjxg849s0vsvk2vcb66ym617nvlj761h0ngz";
        };
      });
    })
  ];

  home.packages = [ pkgs.musescore ];
}
