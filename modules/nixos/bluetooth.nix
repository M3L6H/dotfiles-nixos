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

    environment.persistence."/persist".directories = lib.mkIf config.impermanence.enable [
      "/var/lib/bluetooth" # Bluetooth state
    ];
  };
}
