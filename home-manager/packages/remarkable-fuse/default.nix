{ pkgs, ... }:

let
  # FUSE view of the tablet's xochitl store, with .rm pages rendered to
  # svg/png/pdf (not in nixpkgs).
  remarkable-fuse = pkgs.stdenv.mkDerivation {
    pname = "remarkable-fuse";
    version = "0-unstable-2026-11-07";

    src = pkgs.fetchFromGitHub {
      owner = "sleepybishop";
      repo = "remarkable_fuse";
      rev = "9cb16f9125b9b2b647976b6e271d15e1cf8e81f6";
      hash = "sha256-klzrMDikCTjT9/orf/WpMLCGoq1O+SmkzskPrtBrgGA=";
    };

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = with pkgs; [ fuse3 libpng zlib ];

    installPhase = ''
      install -Dm755 -t $out/bin remfs remfmt pdfoverlay
      mkdir -p $out/share/remarkable-fuse
      cp -r templates $out/share/remarkable-fuse/
    '';
  };

  config = pkgs.writeText "remfs.json" (builtins.toJSON {
    data_dir = "@DATA@/xochitl";
    template_dir = "${remarkable-fuse}/share/remarkable-fuse/templates";
    renderers = [ "svg" "png" "pdf" ];
    # Read-only: the mount is over a local copy that never syncs back.
    mutable = false;
    standalone_annotations = false;
  });

  # Pulls the tablet's documents over the `remarkable` ssh host, then mounts.
  mount = pkgs.writeShellScriptBin "remarkable-mount" ''
    set -euo pipefail
    data="''${XDG_DATA_HOME:-$HOME/.local/share}/remarkable-fuse"
    mnt="''${1:-$HOME/reMarkable}"
    mkdir -p "$data/xochitl" "$mnt"
    ${pkgs.rsync}/bin/rsync -a --delete remarkable:.local/share/remarkable/xochitl/ "$data/xochitl/"
    sed "s|@DATA@|$data|" ${config} > "$data/config.json"
    if mountpoint -q "$mnt"; then fusermount3 -u "$mnt"; fi
    ${remarkable-fuse}/bin/remfs --config="$data/config.json" -o ro "$mnt"
    echo "Mounted at $mnt"
  '';

  umount = pkgs.writeShellScriptBin "remarkable-umount" ''
    fusermount3 -u "''${1:-$HOME/reMarkable}"
  '';
in
{
  home.packages = [ remarkable-fuse mount umount ];
}
