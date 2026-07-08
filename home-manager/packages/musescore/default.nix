{ pkgs2411, ... }:

{
  # musescore 4.7.0 (nixos-26.05) crashes at QQmlConnections::connectSignalsToMethods
  # on Qt 6.9 when opening the New Score dialog. Pulling 4.4.3 from nixos-24.11
  # which was built against Qt 6.7 and doesn't have this regression.
  home.packages = [ pkgs2411.musescore ];
}
