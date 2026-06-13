{ pkgs, ... }:

{
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
}
