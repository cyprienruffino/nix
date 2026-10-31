# cloudlens — AWS resource browser TUI, not in nixpkgs. Needs the AWS creds
# that come with awscli2 in ../../packages.nix. Work-only, so it gates itself
# on the custom.work.enable flag defined in ../../default.nix.
{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.custom.work.enable {
    home.packages = [
      (pkgs.buildGoModule {
        pname = "cloudlens";
        version = "0.1.4";

        src = pkgs.fetchFromGitHub {
          owner = "one2nc";
          repo = "cloudlens";
          rev = "v0.1.4";
          hash = "sha256-b0i9xaIm42RKWzzZdSAmapbmZDmTpCa4IxVsM9eSMqM=";
        };

        vendorHash = "sha256-7TxtM0O3wlfq0PF5FGn4i+Ph7dWRIcyLjFgnnKITLGM=";

        doCheck = false;
      })
    ];
  };
}
