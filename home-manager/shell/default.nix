{ ... }:

{
  programs.bash.enable = true;

  home.shellAliases = {
    hms = "home-manager switch --flake /home/cyprien/nix";
    hmn = "home-manager news --flake /home/cyprien/nix";
  };
}
