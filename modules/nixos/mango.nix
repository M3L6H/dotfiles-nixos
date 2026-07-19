{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    mango.enable = lib.mkEnableOption "enables mango module";
  };

  config = lib.mkIf config.mango.enable {
    programs.mango = {
      enable = true;
    };

    environment.sessionVariables = {
      # Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
      # Enable compatibility between the EGL API and the Wayland protocol
      egl-wayland

      # Screen Sharing
      xdg-desktop-portal-wlr

      # App launcher
      rofi
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
