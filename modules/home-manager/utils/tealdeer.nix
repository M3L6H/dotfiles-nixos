{
  config,
  lib,
  ...
}:
{
  options = {
    utils.tealdeer.enable = lib.mkEnableOption "enables tealdeer module";
  };

  config = lib.mkIf config.utils.tealdeer.enable {
    programs.tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
          auto_update_interval_hours = 24;
        };
      };
    };

    home.persistence."/persist".directories = lib.mkIf config.impermanence.enable [
      ".cache/tealdeer"
    ];
  };
}
