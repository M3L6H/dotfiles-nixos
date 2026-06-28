{
  config,
  lib,
  username,
  ...
}:
with lib;
{
  options = {
    vpn.enable = lib.mkEnableOption "enables vpn module";
    vpn.torrent.enable = lib.mkEnableOption "enables torrent module";
  };

  imports = [
    ./nordvpn.nix
  ];

  config = mkIf config.vpn.enable {
    vpn.torrent.enable = lib.mkDefault true;

    custom.services.nordvpn.enable = true;
    users.users."${username}".extraGroups = [
      "nordvpn"
    ]
    ++ optionals config.vpn.torrent.enable [ "qbittorrent" ];

    services.qbittorrent = {
      enable = config.vpn.torrent.enable;
      webuiPort = 8666;
      openFirewall = true;
      serverConfig = {
        Preferences = {
          WebUI = {
            LocalHostAuth = true;
          };
        };
      };
    };

    systemd.services.qbittorrent = {
      after = [
        "nordvpn.target" # Start after VPN
      ];

      serviceConfig = {
        ProtectHome = mkForce false; # Unblock home directory
        ReadWritePaths = "/home/${username}/files/downloads";
        UMask = "0002"; # Allow directory creation
      };
    };

    environment.persistence."/persist" = mkIf config.impermanence.enable {
      hideMounts = true;

      directories = [
        "/var/lib/nordvpn"
        {
          directory = "/var/lib/qBittorrent";
          user = "qbittorrent";
          group = "qbittorrent";
          mode = "0755";
        }
      ];
    };
  };
}
