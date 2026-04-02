{ config, lib, ... }:
{
  options = {
    user-dirs.enable = lib.mkEnableOption "enables user dirs module";
  };

  config = lib.mkIf config.user-dirs.enable {
    xdg.userDirs = {
      enable = true;
      setSessionVariables = false;

      desktop = "${config.home.homeDirectory}/desktop";
      documents = null;
      download = "${config.home.homeDirectory}/downloads";
      music = null;
      pictures = null;
      publicShare = null;
      templates = null;
      videos = null;
    };
  };
}
