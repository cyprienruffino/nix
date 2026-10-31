# Work git identity for repos under ~/dev/; the personal email set in
# packages/git stays the default everywhere else. Work-only, so it gates
# itself on the custom.work.enable flag defined in ../../default.nix.
{ config, lib, ... }:

{
  config = lib.mkIf config.custom.work.enable {
    programs.git.includes = [{
      condition = "gitdir:~/dev/";
      contents.user.email = "cyprien@runwayml.com";
    }];
  };
}
