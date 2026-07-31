{ claude-desktop-pkg, ... }:

{
  # Claude Desktop for Linux, from the aaddrick/claude-desktop-debian flake
  # (not in nixpkgs). The `default` output is the FHS-wrapped variant.
  home.packages = [ claude-desktop-pkg ];
}
