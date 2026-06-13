{ pkgs, ... }:

{
  xdg.dataFile."applications/plasma-manager-commands.desktop".text = ''
    [Desktop Entry]
    Name=Plasma Manager
    Type=Application
    NoDisplay=true

    [Desktop Action rofi]
    Name=Launch Rofi
    Exec=${pkgs.rofi}/bin/rofi -show drun

    [Desktop Action quick-access-terminal]
    Name=Quick Access Terminal
    Exec=${pkgs.kitty}/bin/kitty kitten quick_access_terminal
  '';

  programs.plasma = {
    enable = true;

    # hotkeys.commands writes to [plasma-manager-commands.desktop] (KDE 5 format).
    # KDE 6 uses [services][plasma-manager-commands.desktop] — write it directly.
    configFile."kglobalshortcutsrc"."services/plasma-manager-commands.desktop" = {
      _k_friendly_name = "Plasma Manager";
      "quick-access-terminal" = "F7,,Quick Access Terminal";
      "rofi" = "ctrl+space,,Launch Rofi";
    };

    panels = [
      {
        location = "top";
        floating = false;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];
  };
}
