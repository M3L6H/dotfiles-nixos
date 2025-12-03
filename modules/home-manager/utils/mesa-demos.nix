{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    utils.mesa-demos.enable = lib.mkEnableOption "enables mesa-demos module";
  };

  config = lib.mkIf config.utils.mesa-demos.enable {
    home.packages = with pkgs; [
      mesa-demos
    ];
  };
}
