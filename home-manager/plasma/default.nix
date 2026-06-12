{ pkgs, ... }:

{
  # plasma-manager's hotkeys module writes kglobalshortcutsrc but relies on
  # xdg.desktopEntries to create the .desktop file, which wasn't being generated.
  # We create it manually so KDE can resolve the actions.
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

    hotkeys.commands."rofi" = {
      name = "Launch Rofi";
      key = "ctrl+space";
      command = "rofi -show drun";
    };

    hotkeys.commands."quick-access-terminal" = {
      name = "Quick Access Terminal";
      key = "F7";
      command = "kitten quick_access_terminal";
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
