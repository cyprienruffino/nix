{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.python3 ];

  # Create a persistent user venv at ~/.venv on first hms run
  home.activation.createPythonVenv = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.venv" ]; then
      ${pkgs.python3}/bin/python3 -m venv "$HOME/.venv"
    fi
  '';
}
