{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    quickshell.enable = mkEnableOption "enable quickshell module";
  };

  config =
    let
      pkg = inputs.quickshell.packages.${system}.default;
      system = pkgs.stdenv.hostPlatform.system;
    in
    mkIf config.quickshell.enable {
      home.packages = with pkgs; [
        qt6.qttools
        qt6.qtbase.dev
        qt6.qtdoc
      ];

      programs.quickshell = {
        enable = true;
        package = pkg;

        systemd = {
          enable = true;
          target = mkIf config.mango.enable "mango-session.target";
        };
      };

      home.file.".config/quickshell" = {
        source = ./markup;
        recursive = true;
      };

      home.file.".local/state/quickshell/generated/defaultColors.json".source = ./defaultColors.json;
    };
}
