{
  ...
}:
{
  config = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "hanekawa" = {
          Hostname = "192.168.1.12";
          Port = 7272;
          User = "m3l6h";
          IdentityFile = "~/.ssh/id_gpg_2026.pub";
          IdentitiesOnly = "yes";
          RemoteForward = "/run/user/1000/gnupg/S.gpg-agent /run/user/1001/gnupg/S.gpg-agent.extra";
        };
      };
    };
  };
}
