{ ... }:
{
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "octopi.local" = {
          Hostname = "192.168.1.59";
          Port = 7272;
          User = "pi";
          IdentityFile = "~/.ssh/id_gpg_2026.pub";
          IdentitiesOnly = "yes";
        };
        "shinobu" = {
          Hostname = "192.168.1.98";
          Port = 7272;
          User = "m3l6h";
          IdentityFile = "~/.ssh/id_gpg_2026.pub";
          IdentitiesOnly = "yes";
        };
      };
    };
  };
}
