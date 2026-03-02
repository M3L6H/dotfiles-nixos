{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    utils.sysstat.enable = lib.mkEnableOption "enables sysstat module";
  };

  config = lib.mkIf config.utils.sysstat.enable {
    home.packages = with pkgs; [
      sysstat
    ];
  };
}
