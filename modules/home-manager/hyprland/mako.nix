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
      # Notifications
      mako
      libnotify
    ];

    home.file.".config/mako/config" = {
      source = ./mako.ini;
    };

    wayland.windowManager = mkIf config.hyprland.enable {
      hyprland.settings.bind = [
        {
          _args = [
            "SUPER + M"
            (generators.mkLuaInline "hl.dsp.exec_cmd(\"makoctl dismiss -a\")")
            { description = "Dismiss notifications"; }
          ];
        }
      ];
    };
  };
}
