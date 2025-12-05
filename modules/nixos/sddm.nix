{ config, lib, ... }:
{
  options = {
    sddm.enable = lib.mkEnableOption "enables sddm module";
  };

  config = lib.mkIf config.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.desktopManager.plasma6.enable = !config.hyprland.enable;

    services.displayManager.defaultSession =
      if config.hyprland.enable then "hyprland-uwsm" else "plasma";
  };
}
