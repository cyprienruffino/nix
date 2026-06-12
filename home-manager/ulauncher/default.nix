{ pkgs, ... }:

{
  home.packages = [ pkgs.ulauncher ];

  xdg.configFile."autostart/ulauncher.desktop".text = ''
    [Desktop Entry]
    Name=Ulauncher
    Comment=Application launcher for Linux
    Exec=ulauncher --hide-window
    Icon=ulauncher
    Terminal=false
    Type=Application
    Categories=Utility;
    X-GNOME-Autostart-enabled=true
  '';
}
