{ pkgs, ... }:

let
  theme = pkgs.writeText "rofi-dark.rasi" ''
    * {
      bg:       #1e1e2e;
      bg-alt:   #313244;
      fg:       #cdd6f4;
      accent:   #89b4fa;

      background-color: transparent;
      text-color:       @fg;
    }

    window {
      background-color: @bg;
      border:           2px solid;
      border-color:     @accent;
      border-radius:    8px;
      width:            600px;
      padding:          16px;
    }

    mainbox   { spacing: 8px; }

    inputbar {
      background-color: @bg-alt;
      border-radius:    4px;
      padding:          8px 12px;
      spacing:          8px;
      children:         [ prompt, entry ];
    }

    prompt    { text-color: @accent; }
    entry     { placeholder: ""; }

    listview {
      lines:      8;
      scrollbar:  false;
      spacing:    4px;
    }

    element {
      border-radius: 4px;
      padding:       8px 12px;
      spacing:       8px;
      children:      [ element-icon, element-text ];
    }

    element selected {
      background-color: @bg-alt;
      text-color:       @accent;
    }

    element-icon  { size: 1.2em; }
    element-text  { vertical-align: 0.5; }
  '';
in

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = "${theme}";
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
