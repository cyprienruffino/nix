{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "cleandownloads" ''
      rm -f ~/Downloads/*.zip ~/Downloads/*.tar.gz ~/Downloads/*.tar.xz \
            ~/Downloads/*.tgz ~/Downloads/*.torrent ~/Downloads/*.rar \
            ~/Downloads/*.7z
    '')

    (pkgs.writeShellScriptBin "latex-clean" ''
      exts=".aux .lof .log .lot .fls .out .toc .dvi .bbl .bcf .blg -blx.aux -blx.bib .run.xml .fdb_latexmk .synctex.gz .pdfsync .nav .snm .vrb .acn .acr .glg .glo .gls .idx .ilg .ind .ist .maf .mtc .mtc0 .nlo .tdo .xdy"
      for x in "''${@:-.}"; do
        arg=$(echo "''${x:-.}" | sed 's/\.\(tex\|pdf\)$//')
        if [[ -d "$arg" ]]; then
          for ext in $exts; do rm -f "$arg"/*$ext; done
        else
          for ext in $exts; do rm -f "$arg"$ext; done
        fi
      done
    '')

    (pkgs.writeShellScriptBin "nap" ''
      killall electron
      echo "Napping for $1 minutes"
      sleep ''${1}m && ${pkgs.mpv}/bin/mpv ~/.local/res/alarm.mp4
      ferdium & disown
    '')

    # Note: tpad uses xinput (X11). May not work under Wayland.
    (pkgs.writeShellScriptBin "tpad" ''
      INPUTID=$(${pkgs.xorg.xinput}/bin/xinput list | grep ouchpad | sed -E 's/(.*)id=(.*)/\2/' | sed -E 's/(.*)\[(.*)/\1/')
      if [ -f ".tpadlock" ]; then
        rm .tpadlock
        ${pkgs.xorg.xinput}/bin/xinput enable $INPUTID
      else
        touch .tpadlock
        ${pkgs.xorg.xinput}/bin/xinput disable $INPUTID
      fi
    '')
  ];
}
