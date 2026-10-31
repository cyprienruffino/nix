# Zoom Workplace (video conferencing). Work-only, so it gates itself on the
# custom.work.enable flag defined in ../../default.nix.
{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.custom.work.enable {
    home.packages = [ pkgs.zoom-us ];

    # Zoom Workplace on Linux exposes no in-app dark-mode toggle; it only follows
    # the (already dark) system theme when `useSystemTheme=true` in zoomus.conf.
    # Zoom ships that key as false. We can't manage zoomus.conf with home.file —
    # it's runtime state (device IDs, caches, current meeting) that Zoom rewrites
    # constantly — so we patch just this one key on each switch instead.
    home.activation.zoomUseSystemTheme =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        cfg="$HOME/.config/zoomus.conf"
        if [ -f "$cfg" ]; then
          if grep -q '^useSystemTheme=' "$cfg"; then
            run ${pkgs.gnused}/bin/sed -i \
              's/^useSystemTheme=.*/useSystemTheme=true/' "$cfg"
          else
            run ${pkgs.gnused}/bin/sed -i \
              '/^\[General\]/a useSystemTheme=true' "$cfg"
          fi
        fi
      '';
  };
}
