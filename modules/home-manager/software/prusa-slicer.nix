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
    home.packages = with pkgs; [
      prusa-slicer
    ];

    home.persistence."/persist".directories = lib.mkIf config.impermanence.enable [
      ".config/PrusaSlicer"
      ".local/share/prusa-slicer"
    ];
  };
}
