# Work-only shell environment, mirroring home-manager/shell/. Gated on
# custom.work.enable like every work module.
{ config, lib, ... }:

{
  config = lib.mkIf config.custom.work.enable {
    # Global npm installs (`npm i -g`, prefix ~/.npm-global) land here.
    home.sessionPath = [ "$HOME/.npm-global/bin" ];
  };
}
