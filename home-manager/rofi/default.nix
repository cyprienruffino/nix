{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
    };
  };
}
