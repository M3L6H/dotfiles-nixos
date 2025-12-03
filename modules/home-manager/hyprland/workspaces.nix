{ config, lib, ... }:
{
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      "workspace" = [
        "1, monitor:DP-1"
        "2, monitor:DP-2"
        "3, monitor:HDMI-A-1"
      ];

      "windowrule" = [
        # Workspace rules
        "match:class Godot, workspace 1"
        "match:class .*tty, workspace 2"
        "match:class vivaldi.*, workspace 3"

        # Godot rules
        "match:class Godot, maximize on"
        "match:class Godot, tile on"
      ];
    };
  };
}
