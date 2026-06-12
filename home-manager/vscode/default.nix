{ pkgs, lib, ... }:

{
  programs.vscode = {
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
    for ext_dir in "$HOME"/.vscode/extensions/anthropic.claude-code-*/; do
      native_bin="$ext_dir/resources/native-binary/claude"
      if [ -d "$ext_dir" ]; then
        ln -sf "$HOME/.nix-profile/bin/claude" "$native_bin"
      fi
    done
  '';
}
