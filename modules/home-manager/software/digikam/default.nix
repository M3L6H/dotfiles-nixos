{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    software.digikam.enable = lib.mkEnableOption "enables digikam module";
  };

  config = lib.mkIf config.software.digikam.enable {
    home = {
      packages = with pkgs; [
        digikam
        exiftool
      ];
    }
    // lib.mkIf config.impermanence.enable {
      persistence."/persist" = {
        directories = [
          ".local/share/digikam"
          "digikam"
        ];

        files = [
          ".config/digikam_systemrc"
          ".config/digikamrc"
        ];
      };
    };
  };
}
