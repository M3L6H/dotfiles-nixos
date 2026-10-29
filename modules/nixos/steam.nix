{
  config,
  lib,
  pkgs,
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
  };
}
