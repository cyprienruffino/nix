{ pkgs, config, lib, ... }:

{
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
