{ pkgs, ... }:

{
  # Make fontconfig pick up fonts installed through home-manager.
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
