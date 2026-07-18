{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    software.anki.enable = mkEnableOption "enables anki module";
  };

  config = mkIf config.software.anki.enable {
    home.packages = with pkgs; [
      anki-bin
    ];
  };
}
