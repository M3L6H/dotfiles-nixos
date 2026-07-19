{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    utils.playerctl.enable = mkEnableOption "enables playerctl module";
  };

  config = mkIf config.utils.playerctl.enable {
    home.packages = with pkgs; [
      playerctl
    ];

    services.playerctld.enable = true;

    wayland.windowManager.mango.settings.bind = mkIf config.mango.enable [
      "NONE,XF86AudioPlay,spawn,playerctl play-pause"
      "NONE,XF86AudioPrev,spawn,playerctl previous"
      "NONE,XF86AudioNext,spawn,playerctl next"
    ];
  };
}
