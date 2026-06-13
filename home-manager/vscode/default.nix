{ pkgs, lib, ... }:

{
  programs.vscodium = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      anthropic.claude-code
    ];
    profiles.default.userSettings = {
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.profiles.linux" = {
        "zsh" = { path = "/home/cyprien/.nix-profile/bin/zsh"; };
      };
      "claudeCode.cliPath" = "/home/cyprien/.nix-profile/bin/claude";
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
