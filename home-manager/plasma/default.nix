{ ... }:

{
  programs.plasma = {
    enable = true;

    workspace.wallpaper = ../../res/wallpaper.jpg;

    configFile."kwinrc"."ModifierOnlyShortcuts"."Meta" = "org.kde.kglobalaccel,/component/kwin,org.kde.kglobalaccel.Component,invokeShortcut,Overview";

    # Remove Meta from the app launcher shortcut so kwin's ModifierOnlyShortcuts wins.
    configFile."kglobalshortcutsrc"."plasmashell"."activate application launcher" = "Alt+F1,Meta\\tAlt+F1,Activer le lanceur d'applications";

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
          "org.kde.plasma.lock_logout"
        ];
      }
    ];
  };
}
