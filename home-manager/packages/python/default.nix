{ pkgs, lib, ... }:

let
  pipPackages = [
    "llm"
  ];
in
{
  home.packages = [ pkgs.python3 ];

  home.activation.createPythonVenv = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.venv" ]; then
      ${pkgs.python3}/bin/python3 -m venv "$HOME/.venv"
      "$HOME/.venv/bin/pip" install ${lib.escapeShellArgs pipPackages}
    fi
  '';
}
