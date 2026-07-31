{ pkgs, ... }:

{
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
}
