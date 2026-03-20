{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    utils.battery.enable = lib.mkEnableOption "enables battery module";
  };

  config = lib.mkIf config.utils.battery.enable {
    home.packages = with pkgs; [
      acpi
      upower
    ];
  };
}
