{ pkgs, lib, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "ccc" ''
      export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:$LD_LIBRARY_PATH"
      exec /home/cyprien/.local/share/pipx/venvs/cocoindex-code/bin/ccc "$@"
    '')
  ];

  home.activation.removeCccPipxShim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -f "$HOME/.local/bin/ccc"
  '';
}
