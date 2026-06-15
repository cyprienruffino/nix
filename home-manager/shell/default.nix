{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    history = {
      size = 1000;
      save = 1000;
    };

    shellAliases = {
      hms  = "git -C /home/cyprien/nix add -A && home-manager switch --flake /home/cyprien/nix -b backup";
      hmn  = "home-manager news --flake /home/cyprien/nix";
      nrs = "sudo nixos-rebuild switch --flake /home/cyprien/nix";
      nfu = "nix flake update  --flake /home/cyprien/nix";
      ls   = "ls --color=auto";
      grep = "grep --color=auto";
      ssh        = "TERM=xterm-256color ssh";
      llm  = "llm -m claude-sonnet-4.6 -s 'You are currently run in a zsh terminal with a very small text display. Do not exceed 500 characters. If I ask you to give me a command, you HAVE to cut out unnecessary text, summaries, comments. Go straight to the point, do not give additional information, cut the fluff.'";
    };

    initContent = builtins.readFile ./zshrc;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.sessionVariables = {
    EDITOR = "nano";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];
}
