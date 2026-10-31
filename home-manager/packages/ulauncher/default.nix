{ lib, pkgs, ... }:

let
  themeName = "catppuccin-mocha";

  # Ulauncher rewrites settings.json itself whenever the preferences window
  # saves, so it cannot be a read-only store symlink. Install a writable copy
  # instead: the GUI keeps working and every `hms` resets it to this value.
  settings = pkgs.writeText "ulauncher-settings.json" (builtins.toJSON {
    clear-previous-query = true;
    disable-desktop-filters = false;
    grab-mouse-pointer = false;
    # Upstream's Wayland instructions: point Ulauncher's own hotkey at an
    # unused combo and bind `ulauncher-toggle` in the DE instead — ctrl+space
    # comes from the KWin shortcut in ../plasma. Leaving both on ctrl+space
    # would toggle the window twice under an X11 session.
    # https://github.com/Ulauncher/Ulauncher/wiki/Hotkey-In-Wayland
    hotkey-show-app = "<Primary><Alt><Shift>F12";
    render-on-screen = "mouse-pointer-monitor";
    show-indicator-icon = true;
    show-recent-apps = "5";
    terminal-command = "${pkgs.kitty}/bin/kitty";
    theme-name = themeName;
  });
in

{
  # wmctrl is what `ulauncher-toggle` uses to raise the window after the dbus
  # call — required for the Wayland hotkey path. The nixpkgs wrapper already
  # hardcodes its store path, so this is only for running wmctrl by hand.
  home.packages = with pkgs; [ ulauncher wmctrl ];

  # Ulauncher is a daemon toggled over dbus; it has no upstream NixOS/HM
  # module, so run it ourselves. GDK_BACKEND=x11 because the GTK3 UI
  # misbehaves natively on Wayland (upstream ships the same workaround).
  systemd.user.services.ulauncher = {
    Unit = {
      Description = "Ulauncher application launcher";
      Documentation = "https://ulauncher.io/";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      Environment = [ "GDK_BACKEND=x11" ];
      ExecStart = "${pkgs.ulauncher}/bin/ulauncher --hide-window --no-window-shadow";
      Restart = "always";
      RestartSec = 1;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."ulauncher/user-themes/${themeName}/manifest.json".text =
    builtins.toJSON {
      manifest_version = "1";
      name = themeName;
      display_name = "Catppuccin Mocha";
      extend_theme = "dark";
      css_file = "theme.css";
      "css_file_gtk_3.20+" = "theme.css";
      matched_text_hl_colors = {
        when_selected = "#89b4fa";
        when_not_selected = "#89b4fa";
      };
    };

  xdg.configFile."ulauncher/user-themes/${themeName}/theme.css".text = ''
    @define-color bg_color               #1e1e2e;
    @define-color window_bg              @bg_color;
    @define-color window_border_color    #89b4fa;
    @define-color prefs_backgroud        #313244;

    @define-color selected_bg_color      #313244;
    @define-color selected_fg_color      #cdd6f4;
    @define-color input_color            #cdd6f4;
    @define-color caret_color            #89b4fa;

    @define-color item_name              #cdd6f4;
    @define-color item_text              #a6adc8;
    @define-color item_box_selected      #313244;
    @define-color item_text_selected     #cdd6f4;
    @define-color item_name_selected     #89b4fa;
    @define-color item_shortcut_color    #6c7086;
    @define-color item_shortcut_color_sel #89b4fa;

    .app {
      border: 2px solid @window_border_color;
      border-radius: 8px;
    }

    .selected.item-box {
      border-radius: 4px;
      border-left: none;
      border-right: none;
    }
  '';

  home.activation.ulauncherSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${settings} "$HOME/.config/ulauncher/settings.json"
  '';
}
