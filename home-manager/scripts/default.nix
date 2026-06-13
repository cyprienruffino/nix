{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "fakecompil"     (builtins.readFile ./fakecompil.sh))
    (pkgs.writeShellScriptBin "cleandownloads" (builtins.readFile ./cleandownloads.sh))
    (pkgs.writeShellScriptBin "latex-clean"    (builtins.readFile ./latex-clean.sh))

    (pkgs.writeShellScriptBin "nap" ''
      killall electron
      echo "Napping for $1 minutes"
      sleep ''${1}m && ${pkgs.mpv}/bin/mpv ~/.local/res/alarm.mp4
      ferdium & disown
    '')

    # Note: tpad uses xinput (X11). May not work under Wayland.
    (pkgs.writeShellScriptBin "tpad" ''
      INPUTID=$(${pkgs.xinput}/bin/xinput list | grep ouchpad | sed -E 's/(.*)id=(.*)/\2/' | sed -E 's/(.*)\[(.*)/\1/')
      if [ -f ".tpadlock" ]; then
        rm .tpadlock
        ${pkgs.xinput}/bin/xinput enable $INPUTID
      else
        touch .tpadlock
        ${pkgs.xinput}/bin/xinput disable $INPUTID
      fi
    '')
  ];
}
