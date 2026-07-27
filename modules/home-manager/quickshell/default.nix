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
      system = pkgs.stdenv.hostPlatform.system;
    in
    mkIf config.quickshell.enable {
      home.packages = with pkgs; [
        inputs.quickshell.packages.${system}.default
        qt6.qttools
        qt6.qtbase.dev
        qt6.qtdoc
      ];

      home.file.".config/quickshell" = {
        source = ./markup;
        recursive = true;
      };

      home.file.".local/state/quickshell/generated/defaultColors.json".source = ./defaultColors.json;
    };
}
