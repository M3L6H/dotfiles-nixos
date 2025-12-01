{
  config,
  lib,
  pkgs,
  username,
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

    home.persistence."/persist/home/${username}" = lib.mkIf config.impermanence.enable {
      directories = [
        ".config/PrusaSlicer"
        ".local/share/prusa-slicer"
      ];

      allowOther = false;
    };
  };
}
