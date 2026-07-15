{ pkgsUnstable, ... }:

{
  # musescore 4.7.0 (nixos-26.05) crashes at QQmlConnections::connectSignalsToMethods
  # on Qt 6.11 when opening the New Score dialog. 4.7.3 from nixpkgs-unstable
  # ships the same Qt 6.11.1 (no GPU lib mixing) and likely has the compat fixes.
  home.packages = [ pkgsUnstable.musescore ];
}
