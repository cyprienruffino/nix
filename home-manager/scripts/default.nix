{ pkgs, ... }:

let
  inject = file: subs:
    builtins.foldl'
      (s: sub: builtins.replaceStrings [ sub.placeholder ] [ sub.value ] s)
      (builtins.readFile file)
      subs;
in

{
  home.packages = [
    (pkgs.writeShellScriptBin "fakecompil"     (builtins.readFile ./fakecompil.sh))
    (pkgs.writeShellScriptBin "cleandownloads" (builtins.readFile ./cleandownloads.sh))
    (pkgs.writeShellScriptBin "latex-clean"    (builtins.readFile ./latex-clean.sh))

    (pkgs.writeShellScriptBin "nap" (inject ./nap.sh [
      { placeholder = "@mpv@";    value = "${pkgs.mpv}"; }
    ]))

    (pkgs.writeShellScriptBin "tpad" (inject ./tpad.sh [
      { placeholder = "@xinput@"; value = "${pkgs.xinput}"; }
    ]))
  ];
}
