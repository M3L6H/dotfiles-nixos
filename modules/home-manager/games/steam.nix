{
  config,
  lib,
  ...
}:
with lib;
{
  options = {
    games.steam.enable = mkEnableOption "enables steam module";
  };

  config = mkIf config.games.steam.enable {
    wayland.windowManager.mango.settings = mkIf config.mango.enable {
      bind = [
        "SUPER,S,spawn,steam"
      ];
      window_rule = [
        "tags:9,app_id:steam"
      ];
    };
  };
}
