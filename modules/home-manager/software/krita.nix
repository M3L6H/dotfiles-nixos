{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    software.krita.enable = lib.mkEnableOption "enables krita module";
  };

  config = lib.mkIf config.software.krita.enable {
    home = {
      packages = with pkgs; [
        krita
      ];
    }
    // lib.mkIf config.impermanence.enable {
      persistence."/persist" = {
        directories = [
          ".local/share/krita"
        ];

        files = [
          ".config/kritadisplayrc"
          ".config/kritarc"
        ];
      };
    };
  };
}
