{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      python.symbol = "󰌠 ";

      direnv = {
        disabled = false;
        symbol = " ";
        # Icon only; the default prints "loaded/allowed" next to it.
        format = "[$symbol]($style) ";
      };

      # Icon only; the default adds "impure/pure (shell name)".
      nix_shell.format = "via [$symbol]($style)";

      kubernetes = {
        disabled = false;
        symbol = "󱃾 ";
      };
    };
  };
}
