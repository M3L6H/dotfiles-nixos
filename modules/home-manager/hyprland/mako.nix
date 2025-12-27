{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hyprland.enable {
    home.packages = with pkgs; [
      # Notifications
      mako
      libnotify
    ];

    home.file.".config/mako/config" = {
      source = ./mako.ini;
    };

    wayland.windowManager.hyprland.settings.bind = [
      # Dismiss notifications
      "$mainMod, M, exec, makoctl dismiss -a"
    ];
  };
}
