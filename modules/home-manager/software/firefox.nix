{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    software.firefox.enable = lib.mkEnableOption "enables firefox module";
  };

  config =
    let
      enable = config.software.firefox.enable;
    in
    lib.mkIf enable {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-esr;
      };

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
      };

      home.persistence."/persist".directories = lib.mkIf config.impermanence.enable [
        ".mozilla/firefox"
      ];
    };
}
