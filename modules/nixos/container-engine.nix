{
  config,
  lib,
  username,
  ...
}:
with lib;
{
  options = {
    container-engine.enable = mkEnableOption "enables container-engine module";
  };

  config = mkIf config.container-engine.enable {
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
