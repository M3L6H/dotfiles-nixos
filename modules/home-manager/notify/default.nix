{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = {
    home.packages = with pkgs; [
      # Notifications
      mako
      libnotify
    ];

    home.file.".config/mako" = {
      source = ./config;
      recursive = true;
    };

    wayland.windowManager = {
      hyprland.settings.bind = mkIf config.hyprland.enable [
        {
          _args = [
            "SUPER + M"
            (generators.mkLuaInline "hl.dsp.exec_cmd(\"makoctl dismiss -a\")")
            { description = "Dismiss notifications"; }
          ];
        }
      ];
      mango.settings.bind = mkIf config.mango.enable [
        "SUPER,M,spawn,makoctl dismiss -a"
      ];
    };
  };
}
