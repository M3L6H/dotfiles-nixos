{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    utils.brightness.enable = mkEnableOption "enables brightness module";
  };

  config = mkIf config.utils.brightness.enable {
    home.packages = with pkgs; [
      brightnessctl
    ];

    wayland.windowManager = {
      hyprland.settings.bind = mkIf config.hyprland.enable [
        {
          _args = [
            "XF86MonBrightnessUp"
            (generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl set +5%\")")
            { description = "Brightness up"; }
          ];
        }
        {
          _args = [
            "XF86MonBrightnessDown"
            (generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl set -5%\")")
            { description = "Brightness up"; }
          ];
        }
      ];
      mango.settings.bind = mkIf config.mango.enable [
        "NONE,XF86MonBrightnessUp,spawn,brightnessctl s +5%"
        "SHIFT,XF86MonBrightnessUp,spawn,brightnessctl s 100%"
        "NONE,XF86MonBrightnessDown,spawn,brightnessctl s 5%-"
        "SHIFT,XF86MonBrightnessDown,spawn,brightnessctl s 1%"
      ];
    };
  };
}
