{ config, lib, ... }:
{
  options = {
    pcscd.enable = lib.mkEnableOption "enables PCSC-Lite daemon module";
  };

  config = lib.mkIf config.pcscd.enable {
    services.pcscd.enable = true;
  };
}
