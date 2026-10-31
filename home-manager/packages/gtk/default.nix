{ pkgs, config, lib, ... }:

{
  # Standard workaround for home-manager switch failing with ".gtkrc-2.0
  # would be clobbered": the hm gtk module declares this file under its
  # ABSOLUTE path (gtk2.configLocation), so this merges into that same
  # home.file entry and forces overwriting the stale backup. Fragile across
  # hm versions — if a switch ever fails here again, start at the gtk module.
  home.file."${config.home.homeDirectory}/.gtkrc-2.0".force = lib.mkForce true;

  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}
