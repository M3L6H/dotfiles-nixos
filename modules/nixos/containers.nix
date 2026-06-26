{
  config,
  lib,
  username,
  ...
}:
with lib;
{
  options = {
    containers.enable = mkEnableOption "enables containers module";
  };

  config = mkIf config.containers.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        # Required for containers under podman-compose to be able to talk to each other
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    users.users."${username}".extraGroups = [
      "podman"
    ];
  };
}
