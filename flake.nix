{
  description = "Cyprien's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # Kolide's own flake — the launcher is not in nixpkgs.
    kolide-launcher = {
      url = "github:kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, plasma-manager, kolide-launcher, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};

      # Build the host, optionally layering extra modules on top. The base build
      # leaves the work agents off; `nixos-work` opts in by setting the flag.
      mkHost = extraModules: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./system/configuration.nix
          kolide-launcher.nixosModules.kolide-launcher
        ] ++ extraModules;
      };

      mkHome = extraModules: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit pkgsUnstable; };
        modules = [
          ./home-manager/home.nix
          plasma-manager.homeModules.plasma-manager
        ] ++ extraModules;
      };
    in {
      nixosConfigurations = {
        nixos = mkHost [ ];
        nixos-work = mkHost [ { custom.work.enable = true; } ];
      };

      homeConfigurations = {
        "cyprien@nixos" = mkHome [ ];
        "cyprien@nixos-work" = mkHome [ { custom.work.enable = true; } ];
      };
    };
}
