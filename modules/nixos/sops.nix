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
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    sops.secrets.passwordHash.neededForUsers = true;

    # To be able to decrypt the sops file at boot
    fileSystems."/etc/ssh".neededForBoot = true;

    users.users."${username}".hashedPasswordFile = config.sops.secrets.passwordHash.path;
  };
}
