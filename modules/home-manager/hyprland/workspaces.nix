{ config, lib, ... }:
{
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      window_rule = [
        {
          name = "Godot";
          match = {
            class = "Godot";
          };
          maximize = true;
          tile = true;
          workspace = "4";
        }
        {
          name = "Terminal";
          match = {
            class = ".*tty";
          };
          workspace = "2";
        }
        {
          name = "Browser";
          match = {
            class = "vivaldi.*";
          };
          workspace = "3";
        }
      ];
    };
  };
}
