{ config, lib, ... }:
{
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      "windowrule" = [
        # Workspace rules
        "match:class Godot, workspace 4"
        "match:class .*tty, workspace 2"
        "match:class vivaldi.*, workspace 3"

        # Godot rules
        "match:class Godot, maximize on"
        "match:class Godot, tile on"
      ];
    };
  };
}
