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
    # JumpCloud agent — not in nixpkgs; packaged in a sibling repo.
    jumpcloud-nix = {
      url = "github:cyprienruffino/jumpcloud-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Claude Desktop for Linux — not in nixpkgs. Built against unstable, so
    # follow nixpkgs-unstable rather than our 26.05 pin.
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, plasma-manager, kolide-launcher, jumpcloud-nix, claude-desktop, ... }:
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
          jumpcloud-nix.nixosModules.default
        ] ++ extraModules;
      };

      # Claude Desktop's flake package, ready to drop into home.packages.
      claude-desktop-pkg = claude-desktop.packages.${system}.default;

      mkHome = extraModules: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit pkgsUnstable claude-desktop-pkg; };
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
