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
        AllowUsers = [ username ];
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    users.users.${username}.openssh.authorizedKeys.keyFiles = [
      ./primary_id_ed25519_sk.pub
      ./backup_id_ed25519_sk.pub
    ];
  };
}
