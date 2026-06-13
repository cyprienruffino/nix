{ ... }:

{
  programs.plasma = {
    enable = true;

    workspace.wallpaper = ../../res/wallpaper.jpg;

    # Bind Meta alone to Overview; keep Meta+W as well.
    # Remove Meta from the app launcher so it doesn't conflict.
    shortcuts."kwin"."Overview" = [ "Meta" "Meta+W" ];
    shortcuts."plasmashell"."activate application launcher" = "Alt+F1";

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
