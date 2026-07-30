# Work-mandated agents. Both need a one-time manual enrollment step,
# documented under "Work agents" in the README.
{ ... }:

{
  # Kolide device-compliance agent (from the kolide-launcher flake input).
  # The enrollment secret is deliberately NOT declared here: anything set via
  # environment.etc ends up world-readable in the nix store, and this repo is
  # in git. It lives in /etc/kolide-k2/secret, created out of band.
  services.kolide-launcher.enable = true;

  # Twingate client daemon + the `twingate` CLI.
  # Enrollment is stored in /etc/twingate, written by `sudo twingate setup`.
  services.twingate.enable = true;
}
