{ ... }:

{
  programs.plasma = {
    enable = true;

    workspace.wallpaper = ../../../res/wallpaper.jpg;

    # Drive the Plasma color scheme declaratively. In a Plasma session Qt apps
    # (Zoom, etc.) follow this automatically; our GTK theme is set separately
    # in ../gtk. Zoom still needs its in-app Theme set to "Use system setting".
    workspace.colorScheme = "BreezeDark";

    # Bind Meta alone to Overview; keep Meta+W as well.
    # Remove Meta from the app launcher so it doesn't conflict.
    shortcuts."kwin"."Overview" = [ "Meta" "Meta+W" ];
    shortcuts."plasmashell"."activate application launcher" = "Alt+F1";

    hotkeys.commands."ulauncher" = {
      name = "Launch Ulauncher";
      key = "ctrl+space";
      command = "ulauncher-toggle";
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
