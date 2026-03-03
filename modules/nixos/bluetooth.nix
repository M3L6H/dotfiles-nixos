{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    bluetooth.enable = mkEnableOption "enables bluetooth module";
  };

  config = mkIf config.bluetooth.enable {
    hardware.bluetooth.enable = true;

    environment.systemPackages = with pkgs; [
      bluetui
    ];

    environment.persistence."/persist".directories = lib.optionalAttrs config.impermanence.enable [
      "/var/lib/bluetooth" # Bluetooth state
    ];
  };
}
