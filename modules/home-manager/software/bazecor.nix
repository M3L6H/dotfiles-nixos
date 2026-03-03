{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    software.bazecor.enable = lib.mkEnableOption "enables bazecor module";
  };

  config = lib.mkIf config.software.bazecor.enable {
    home = {
      packages = with pkgs; [
        bazecor
      ];
    }
    // lib.mkIf config.impermanence.enable {
      persistence."/persist".directories = [
        ".config/Bazecor"
        "Dygma"
      ];
    };
  };
}
