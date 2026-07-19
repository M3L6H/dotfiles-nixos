{
  config,
  lib,
  ...
}:
with lib;
{
  options = {
    sddm.enable = mkEnableOption "enables sddm module";
  };

  config =
    let
      defaultSession =
        if config.hyprland.enable then
          "hyprland-uwsm"
        else if config.mango.enable then
          "mango"
        else
          "plasma";
      hasWm = config.hyprland.enable || config.mango.enable;
    in
    mkIf config.sddm.enable {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      services.desktopManager.plasma6.enable = !hasWm;

      services.displayManager = {
        inherit defaultSession;
      };
    };
}
