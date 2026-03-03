{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    software.prusa-slicer.enable = lib.mkEnableOption "enables prusa-slicer module";
  };

  config = lib.mkIf config.software.prusa-slicer.enable {
    home = {
      packages = with pkgs; [
        prusa-slicer
      ];
    }
    // lib.mkIf config.impermanence.enable {
      persistence."/persist".directories = [
        ".config/PrusaSlicer"
        ".local/share/prusa-slicer"
      ];
    };
  };
}
