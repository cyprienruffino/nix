{ ... }:

{
  programs.zsh = {
    enable = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreAllDups = true;
    };

    # No work variants needed: the hostname (nixos vs nixos-work) selects the
    # right flake output for both nixos-rebuild and home-manager.
    # `add --intent-to-add` makes new files visible to the flake (which only
    # sees git-tracked files) without staging their content.
    shellAliases = {
      hms  = "git -C /home/cyprien/nix add --intent-to-add -A && home-manager switch --flake /home/cyprien/nix -b backup";
      hmn  = "home-manager news --flake /home/cyprien/nix";
      nrs = "sudo nixos-rebuild switch --flake /home/cyprien/nix --impure";
      nfu = "nix flake update --flake /home/cyprien/nix";
      nu = "nfu && nrs && hms && hmn";
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nano";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];
}
