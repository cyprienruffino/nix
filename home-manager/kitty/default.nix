{ ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      hide_window_decorations = "yes";
      paste_actions = "quote-urls-at-prompt";
    };
    keybindings = {
      "f7" = "kitten quick_access_terminal";
    };
  };
}
