{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      anthropic.claude-code
    ];
    profiles.default.userSettings = {
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.profiles.linux" = {
        "zsh" = { path = "/home/cyprien/.nix-profile/bin/zsh"; };
      };
    };
  };
}
