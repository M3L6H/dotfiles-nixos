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

  imports = [
    ./tags
  ];

  config =
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    mkIf config.quickshell.enable {
      home.packages = [
        inputs.quickshell.packages.${system}.default
      ];

      home.file.".config/quickshell/shell.qml".source = ./shell.qml;
    };
}
