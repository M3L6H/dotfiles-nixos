{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    software.firefox.enable = mkEnableOption "enables firefox module";
  };

  config =
    let
      enable = config.software.firefox.enable;
    in
    mkIf enable {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-esr;
      };

      wayland.windowManager.mango.settings.bind = mkIf config.mango.enable [
        "SUPER,D,spawn,firefox"
      ];

      home = {
        sessionVariables = {
          MOZ_ENABLE_WAYLAND = 1;
        };
      }
      // optionalAttrs config.impermanence.enable {
        persistence."/persist".directories = [
          ".mozilla/firefox"
        ];
      };
    };
}
