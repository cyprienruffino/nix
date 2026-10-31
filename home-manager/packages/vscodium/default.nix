{ pkgs, lib, ... }:

let
  # Not in nixpkgs yet; the bundled ty binary is replaced via ty.path below.
  ty-extension = pkgs.vscode-utils.buildVscodeExtension {
    pname = "ty";
    version = "2026.72.0";
    vscodeExtPublisher = "astral-sh";
    vscodeExtName = "ty";
    vscodeExtUniqueId = "astral-sh.ty";
    src = pkgs.fetchurl {
      name = "astral-sh-ty.vsix";
      url = "https://open-vsx.org/api/astral-sh/ty/linux-x64/2026.72.0/file/astral-sh.ty-2026.72.0@linux-x64.vsix";
      hash = "sha256-sgUapvQDBJYGhcW35IleQIacwNltI2kcz9ReKMb8Pxw=";
    };
  };
in
{
  programs.vscodium = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      anthropic.claude-code
      ms-python.python
      charliermarsh.ruff
      ty-extension
    ];
    profiles.default.userSettings = {
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.profiles.linux" = {
        "zsh" = { path = "/home/cyprien/.nix-profile/bin/zsh"; };
      };
      "claudeCode.cliPath" = "/home/cyprien/.nix-profile/bin/claude";
      "claudeCode.allowDangerouslySkipPermissions" = true;

      # Python: ruff for lint/format, ty as language server, both from nixpkgs
      # so the extensions' bundled binaries (not NixOS-compatible) are unused.
      "ruff.path" = [ "${pkgs.ruff}/bin/ruff" ];
      "ty.path" = [ "${pkgs.ty}/bin/ty" ];
      "[python]" = {
        "editor.defaultFormatter" = "charliermarsh.ruff";
      };
    };
  };

  # The bundled claude binary inside the extension is not NixOS-compatible.
  # Symlink the nix-profile claude binary in its place after every hms.
 
   home.activation.fixClaudeCodeBinary = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CLAUDE_BIN="$HOME/.nix-profile/bin/claude"
    if [ ! -f "$CLAUDE_BIN" ]; then
      echo "WARNING: claude binary not found at $CLAUDE_BIN, skipping symlink"
    else
      for ext_dir in "$HOME"/.vscode{,-oss}/extensions/anthropic.claude-code-*/; do
        [ -d "$ext_dir" ] || continue
        native_dir="$ext_dir/resources/native-binary"
        mkdir -p "$native_dir"
        ln -sf "$CLAUDE_BIN" "$native_dir/claude"
        echo "Linked claude binary in $native_dir"
      done
    fi
  '';
}
