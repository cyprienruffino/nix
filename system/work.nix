# Work-mandated agents. Each needs a one-time manual enrollment step,
# documented under "Work agents" in the README.
#
# This is opt-in: nothing here is active unless `custom.work.enable = true`,
# which the `nixos-work` flake output sets. A plain `.#nixos` build leaves it off.
{ config, lib, ... }:

{
  options.custom.work.enable =
    lib.mkEnableOption "work-mandated device agents (Kolide, Twingate, JumpCloud)";

  config = lib.mkIf config.custom.work.enable {
    # Distinct hostname so `--flake .` (no fragment) auto-selects the work
    # profile — both for nixos-rebuild and for standalone home-manager, which
    # matches homeConfigurations."cyprien@<hostname>". Prevents a plain `nrs`
    # from silently reverting a work machine to the personal profile and
    # de-enrolling the agents below.
    networking.hostName = "nixos-work";

    # Docker daemon + CLI. The daemon is work-only; the docker group grant
    # lives here too (docker group ≈ passwordless root, so it should not
    # exist on machines without the daemon).
    virtualisation.docker.enable = true;
    users.users."cyprien".extraGroups = [ "docker" ];

    # Kolide device-compliance agent (from the kolide-launcher flake input).
    # The enrollment secret is deliberately NOT declared here: anything set via
    # environment.etc ends up world-readable in the nix store, and this repo is
    # in git. It lives in /etc/kolide-k2/secret, created out of band.
    services.kolide-launcher.enable = true;

    # Twingate client daemon + the `twingate` CLI.
    # Enrollment is stored in /etc/twingate, written by `sudo twingate setup`.
    services.twingate.enable = true;

    # JumpCloud agent (from the jumpcloud-nix flake input — not in nixpkgs).
    # Enrolls for inventory and device trust, NOT user-login/PAM management.
    # The connect key lives in /etc/jumpcloud/connect-key, created out of band.
    services.jumpcloud-agent.enable = true;
  };
}
