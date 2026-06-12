{ ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    extraConfig = ''
      set -g status-style 'bg=#13161d fg=#8b949e'
    '';
  };
}
