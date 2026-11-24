{
  config,
  lib,
  username,
  ...
}:
with lib;
{
  options = {
    ssh.enable = mkEnableOption "enables ssh module";
  };

  config = mkIf config.ssh.enable {
    services.fail2ban.enable = true;

    services.openssh = {
      enable = true;
      ports = [ 7272 ];
      settings = {
        AllowAgentForwarding = true;
        AllowUsers = [ username ];
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        StreamLocalBindUnlink = true;
      };
    };

    users.users.${username}.openssh.authorizedKeys.keyFiles = [
      ./id_gpg_2026.pub
    ];
  };
}
