{
  config,
  lib,
  username,
  ...
}:
{
  options = {
    sops.enable = lib.mkEnableOption "enables sops module";
  };

  config = {
    sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    sops.secrets.passwordHash.neededForUsers = true;

    users.users."${username}".hashedPasswordFile = config.sops.secrets.passwordHash.path;
  };
}
