{ pkgs, ... }:

let
  version = "2.0.0";

  # Desktop app for managing reMarkable mods (not in nixpkgs). It drives the
  # Vellum package manager on the tablet over SSH, so vellum itself is
  # installed on the device, not here.
  remanager = pkgs.stdenv.mkDerivation {
    pname = "remanager";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/rmitchellscott/reManager/releases/download/v${version}/reManager-linux-amd64.tar.gz";
      sha256 = "f086bac6384a86fca0cbab0e7eb5c4be45683ab32e73a7e83645af2dc8849fac";
    };
    icon = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/rmitchellscott/reManager/v${version}/assets/icon.svg";
      sha256 = "ae00ec88e4ad4284755aeef6fbdc6c9af5abe32625bf1512e51ba56a0bed40ec";
    };
    sourceRoot = ".";

    nativeBuildInputs = with pkgs; [ autoPatchelfHook wrapGAppsHook4 ];
    buildInputs = with pkgs; [ gtk4 webkitgtk_6_0 libsoup_3 glib libx11 glib-networking ];

    installPhase = ''
      install -Dm755 reManager $out/bin/remanager
      install -Dm644 $icon $out/share/icons/hicolor/scalable/apps/remanager.svg
    '';
  };
in
{
  home.packages = [ remanager ];

  xdg.desktopEntries.remanager = {
    name = "reManager";
    comment = "Manage mods on reMarkable tablets";
    exec = "remanager";
    icon = "remanager";
    categories = [ "Utility" ];
  };
}
