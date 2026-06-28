{
  config,
  lib,
  username,
  ...
}:
with lib;
{
  options = {
    sops.enable = lib.mkEnableOption "enables sops module";
  };

  config = mkIf config.sops.enable {
    sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    sops.secrets.passwordHash.neededForUsers = true;

    users.users."${username}".hashedPasswordFile = config.sops.secrets.passwordHash.path;
  };
}
