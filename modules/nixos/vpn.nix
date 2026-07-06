{
  config,
  lib,
  pkgs,
  username,
  ...
}:
with lib;
{
  options = {
    vpn.enable = lib.mkEnableOption "enables vpn module";
    vpn.torrent.enable = lib.mkEnableOption "enables torrent module";
  };

  config = mkIf config.vpn.enable {
    environment.systemPackages = with pkgs; [
      nordvpn
    ];

    vpn.torrent.enable = lib.mkDefault true;

    networking.firewall.checkReversePath = "loose";

    users.groups.nordvpn = { };

    systemd.services.nordvpnd = {
      description = "NordVPN daemon.";
      serviceConfig = {
        ExecStart = "${pkgs.nordvpn}/bin/nordvpnd";
        ExecStartPre = pkgs.writeShellScript "nordvpn-start" ''
          mkdir -m 700 -p /var/lib/nordvpn;
          if [ -z "$(ls -A /var/lib/nordvpn)" ]; then
            cp -r ${pkgs.nordvpn}/var/lib/nordvpn/* /var/lib/nordvpn;
          fi
        '';
        NonBlocking = true;
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = 5;
        RuntimeDirectory = "nordvpn";
        RuntimeDirectoryMode = "0750";
        Group = "nordvpn";
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };

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
      after = mkForce [ ];
      before = mkForce [ ];
      startAt = mkForce [ ];
      wantedBy = mkForce [ ];
      wants = mkForce [ ];

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
