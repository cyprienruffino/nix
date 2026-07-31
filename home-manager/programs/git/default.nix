{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Cyprien Ruffino";
        email = "ruffino.cyprien@protonmail.com";
      };
      alias = {
        tree = "log --oneline --decorate --graph";
      };
      credential.helper = "cache";
      protocol.file.allow = "always";
    };
  };
}
