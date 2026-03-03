{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    utils.gh.enable = lib.mkEnableOption "enables gh module";
  };

  config = lib.mkIf config.utils.gh.enable {
    home = {
      packages = with pkgs; [
        gh
      ];
    }
    // lib.mkIf config.impermanence.enable {
      persistence."/persist".directories = [
        ".config/gh"
      ];
    };
  };
}
