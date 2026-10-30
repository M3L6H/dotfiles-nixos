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
    steam.enable = mkEnableOption "enable Steam";
  };

  config = mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      steam-run
    ];

    # Persist
    fileSystems."/home/${username}/.local/share/Steam" = {
      device = "/persist/home/${username}/.local/share/Steam";
      fsType = "none";
      options = [
        "bind"
        "user"
        "exec"
        "noauto"
        "x-systemd.automount"
      ];
    };

    fileSystems."/home/${username}/.local/share/vulkan" = {
      device = "/persist/home/${username}/.local/share/vulkan";
      fsType = "none";
      options = [
        "bind"
        "user"
        "exec"
        "noauto"
        "x-systemd.automount"
      ];
    };

    fileSystems."/home/${username}/.steam" = {
      device = "/persist/home/${username}/.steam";
      fsType = "none";
      options = [
        "bind"
        "user"
        "exec"
        "noauto"
        "x-systemd.automount"
      ];
    };
  };
}
