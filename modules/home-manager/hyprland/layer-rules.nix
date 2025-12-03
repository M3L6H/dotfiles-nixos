{ config, lib, ... }:
{
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      "layerrule" = [
        "match:namespace eww-bar, blur on, ignore_alpha 0"
      ];
    };
  };
}
