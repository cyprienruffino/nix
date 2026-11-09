{ pkgs, ... }:

let
  # wineWowPackages has no binary cache hit on our nixpkgs pin; wineWow64 does.
  wine = pkgs.wineWow64Packages.stable;

  # Official Windows app (no Linux build exists). Qt Installer Framework, so it
  # installs headless on first launch.
  installer = pkgs.fetchurl {
    url = "https://downloads.remarkable.com/desktop/production/win/reMarkable-3.29.0.1804-win64.exe";
    sha256 = "8ea2b5ee68004f0c02ee52ca2ad2bed2786899b40c514425a003c7d9ab0358aa";
  };

  remarkable = pkgs.writeShellScriptBin "remarkable" ''
    export WINEPREFIX="''${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/remarkable"
    export WINEDEBUG=-all
    # Keep Wine from adding its own menu entries; they call a bare `wine` that
    # isn't on PATH and shadow ours.
    export WINEDLLOVERRIDES="winemenubuilder.exe=d"
    exe="$WINEPREFIX/drive_c/Program Files/reMarkable/reMarkable.exe"
    if [ ! -f "$exe" ]; then
      ${wine}/bin/wineboot -i
      ${wine}/bin/wine ${installer} --root 'C:\Program Files\reMarkable' \
        install --accept-licenses --default-answer --confirm-command
      # The app fails to create its own cache dir.
      mkdir -p "$WINEPREFIX/drive_c/users/$USER/AppData/Local/remarkable/desktop/cache"
    fi
    exec ${wine}/bin/wine "$exe" "$@"
  '';
in
{
  home.packages = [ remarkable ];

  xdg.desktopEntries.remarkable = {
    name = "reMarkable";
    comment = "reMarkable desktop app (Windows build under Wine)";
    exec = "remarkable";
    categories = [ "Office" ];
  };
}
