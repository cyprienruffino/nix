{ pkgs, lib, config, ... }:

let
  # TuxGuitar is SWT/GTK, but it paints the score/tab canvas, the matrix and
  # the fretboard itself, with colours read from its own config file. So there
  # are two halves to theme, and doing only one is exactly what produces
  # unreadable white-on-white: dark GTK text over the app's white canvas, or
  # black canvas text under a light GTK theme.
  #
  # Half one: the widgets (menus, dialogs, tables, tabs). Adwaita is built into
  # GTK3, so :dark is always available — unlike Breeze-Dark, which only
  # resolves if the theme package happens to be in the launcher's
  # XDG_DATA_DIRS.
  tuxguitarDark = pkgs.tuxguitar.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      wrapProgram $out/bin/tuxguitar \
        --set GTK_THEME Adwaita:dark
    '';
  });

  # Half two: everything TuxGuitar draws. Roughly the Breeze Dark palette
  # (#232629 base, #eff0f1 text, #3daee9 accent) so it sits next to the rest of
  # the desktop. Printing is unaffected — TuxGuitar prints on its own
  # black-on-white style, not these colours.
  darkColors = {
    "skin" = "Breeze-dark";

    "color.background" = "35,38,41";
    "color.background.playing" = "50,42,42";
    "color.foreground" = "239,240,241";
    "color.line" = "90,95,100";
    "color.line.invalid" = "218,68,83";
    "color.caret.voice.current" = "239,240,241";
    "color.caret.voice.other" = "218,68,83";
    "color.measure.number" = "230,150,150";
    "color.play.note" = "255,80,80";
    "color.score.note" = "239,240,241";
    "color.tab.note" = "239,240,241";
    "color.selection" = "40,90,140";
    "color.loop.s.marker" = "80,200,80";
    "color.loop.e.marker" = "200,80,80";

    "matrix.color.border" = "90,95,100";
    "matrix.color.foreground" = "239,240,241";
    "matrix.color.line-1" = "40,43,46";
    "matrix.color.line-2" = "50,53,60";
    "matrix.color.line-3" = "45,60,75";
    "matrix.color.note" = "61,174,233";
    "matrix.color.play-note" = "255,80,80";
    "matrix.color.position" = "239,240,241";

    "fretboard.color.note" = "61,174,233";
    "fretboard.color.scale" = "218,68,83";
  };

  darkColorsFile = pkgs.writeText "tuxguitar-dark.cfg"
    (lib.concatLines (lib.mapAttrsToList (k: v: "${k}=${v}") darkColors));

  # tuxguitar.cfg cannot be a read-only store symlink: TuxGuitar rewrites the
  # whole file on exit (window geometry, recent files, any GUI setting). So
  # patch just the keys above into it and leave every other line alone.
  patchColors = pkgs.writeShellScript "tuxguitar-apply-dark-theme" ''
    cfg="$1"
    mkdir -p "$(dirname "$cfg")"
    touch "$cfg"
    ${pkgs.gawk}/bin/awk -F= -v OFS== '
      NR == FNR { want[$1] = $2; order[++n] = $1; next }
      $1 in want { print $1, want[$1]; seen[$1] = 1; next }
      { print }
      END { for (i = 1; i <= n; i++) if (!(order[i] in seen)) print order[i], want[order[i]] }
    ' ${darkColorsFile} "$cfg" > "$cfg.tmp"
    mv "$cfg.tmp" "$cfg"
  '';
in
{
  home.packages = [ tuxguitarDark ];

  home.activation.tuxguitarDarkTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${patchColors} ${config.xdg.configHome}/tuxguitar/config/tuxguitar.cfg
  '';
}
