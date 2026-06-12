{ ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      hide_window_decorations = "yes";
      paste_actions = "quote-urls-at-prompt";
    };
  };
}
