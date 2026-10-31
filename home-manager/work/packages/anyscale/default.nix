# Anyscale CLI. Not packaged in nixpkgs (proprietary, pip-only), so we install
# it imperatively as a uv tool on activation rather than as a nix package. uv
# itself is provided globally via home-manager/packages.nix. Work-only, so it
# gates itself on the custom.work.enable flag defined in ../../default.nix.
{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.custom.work.enable {
    # Install anyscale into ~/.local/share/uv/tools (symlinked onto PATH at
    # ~/.local/bin/anyscale) on the first switch, and whenever it's been removed.
    # We skip the PyPI round-trip when it's already present; updates are a manual
    # `uv tool upgrade anyscale`. Not idempotent state we can express purely in
    # Nix, hence an activation script rather than a package.
    home.activation.installAnyscale =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if ! [ -x "$HOME/.local/bin/anyscale" ]; then
          run ${pkgs.uv}/bin/uv tool install anyscale
        fi
      '';
  };
}
