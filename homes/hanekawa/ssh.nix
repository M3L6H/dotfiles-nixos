{ ... }:
{
  config = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "shinobu" = {
          Hostname = "192.168.1.98";
          Port = 7272;
          User = "m3l6h";
          IdentityFile = "~/.ssh/harpocrates_primary_ed25519_sk";
          IdentitiesOnly = "yes";
        };
      };
    };
  };
}
