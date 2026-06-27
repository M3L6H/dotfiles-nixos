{
  ...
}:
{
  config = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "hanekawa" = {
          Hostname = "192.168.1.12";
          Port = 7272;
          User = "m3l6h";
          IdentityFile = "~/.ssh/harpocrates_primary_ed25519_sk";
          IdentitiesOnly = "yes";
          RemoteForward = "/run/user/1000/gnupg/S.gpg-agent /run/user/1001/gnupg/S.gpg-agent.extra";
        };
      };
    };
  };
}
