{ ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      hide_window_decorations = "yes";
      paste_actions = "quote-urls-at-prompt";
    };
    keybindings = {
      "ctrl+page_up" = "previous_tab";
      "ctrl+page_down" = "next_tab";
    };
  };

  xdg.configFile."kitty/quick-access-terminal.conf".text = ''
    edge center
  '';
}
