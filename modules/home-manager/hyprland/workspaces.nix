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
        "workspace 1, class:Godot"
        "workspace 2, class:.*tty"
        "workspace 3, class:vivaldi.*"

        # Godot rules
        "maximize, class:Godot"
        "tile, class:Godot"
      ];
    };
  };
}
