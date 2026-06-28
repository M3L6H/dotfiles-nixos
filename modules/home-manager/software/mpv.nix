{
  config,
  lib,
  ...
}:
with lib;
{
  options = {
    software.mpv.enable = mkEnableOption "enables mpv module";
  };

  config = mkIf config.software.mpv.enable {
    programs.mpv.enable = true;

    wayland.windowManager = mkIf config.hyprland.enable {
      hyprland.settings = {
        window_rule = [
          {
            name = "mpv";
            match = {
              class = "mpv";
            };
            float = true;
            size = (generators.mkLuaInline "{\"monitor_w * 0.5\", \"monitor_w * 0.5 * 0.5625\"}");
            workspace = "6";
          }
        ];
      };
    };
  };
}
