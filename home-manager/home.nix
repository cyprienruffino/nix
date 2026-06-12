{ config, pkgs, ... }:

{
  home.username = "cyprien";
  home.homeDirectory = "/home/cyprien";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # Add user packages here
  ];

  home.shellAliases = {
    hms = "home-manager switch --flake /home/cyprien/nix";
    hmn = "home-manager news --flake /home/cyprien/nix";
  };

  programs.home-manager.enable = true;
}
