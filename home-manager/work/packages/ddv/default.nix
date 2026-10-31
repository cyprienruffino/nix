# ddv — DynamoDB TUI, not in nixpkgs. Sibling of `stu` (the S3 TUI in
# ../../packages.nix, same upstream author). Work-only, so it gates itself on
# the custom.work.enable flag defined in ../../default.nix.
{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.custom.work.enable {
    home.packages = [
      (pkgs.rustPlatform.buildRustPackage {
        pname = "ddv";
        version = "0.3.1";

        src = pkgs.fetchFromGitHub {
          owner = "lusingander";
          repo = "ddv";
          rev = "v0.3.1";
          hash = "sha256-KZEw/nnioD1a3LkCtB1/3YQgizHbeA3UvXyS2RDAl8I=";
        };

        cargoHash = "sha256-VACRGbzJInY1KWlardjzwgjhaJy0WqDwE3ibp/ea6z0=";
      })
    ];
  };
}
