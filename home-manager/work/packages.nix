# Work-only packages, mirroring home-manager/packages.nix: a flat list of
# plain package names. Anything needing more than a name gets its own module
# under programs/. Gated on custom.work.enable like every work module.
{ config, lib, pkgs, pkgsUnstable, ... }:

{
  config = lib.mkIf config.custom.work.enable {
    home.packages = with pkgs; [
      awscli2
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
      terraform
      opentofu
      nodejs
      biome
      oci-cli
      packer
      kubectl
      kubernetes-helm
      helmfile
      circleci-cli
      kubelogin-oidc
      kubie
      kustomize
      argocd
      k9s
      stu
      # Modal CLI (serverless GPU platform) — the python package ships the `modal` binary.
      python3Packages.modal
      # vector — provides `vector vrl` to validate/test VRL (Vector Remap
      # Language) programs. See https://vector.dev/docs/reference/vrl/
      vector
      # coder CLI — pulled from unstable to match the coder.ops.runwayml.com
      # server version (26.05 lags several minors behind).
      pkgsUnstable.coder
    ];
  };
}
