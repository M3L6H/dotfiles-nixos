{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.hyprland.enable {
    home.packages = with pkgs; [
      hyprshot
    ];

    wayland.windowManager = mkIf config.hyprland.enable {
      hyprland.settings.bind = [
        {
          _args = [
            "SUPER + PRINT"
            (generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprshot -m window\")")
            { description = "Screenshot a window"; }
          ];
        }
        {
          _args = [
            "PRINT"
            (generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprshot -m active -m window\")")
            { description = "Screenshot active window"; }
          ];
        }
        {
          _args = [
            "SUPER + SHIFT + PRINT"
            (generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprshot -m region\")")
            { description = "Screenshot a region"; }
          ];
        }
      ];
    };
  };
}
