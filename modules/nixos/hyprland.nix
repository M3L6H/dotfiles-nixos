{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland module";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.uwsm.enable = true;

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland;
      portalPackage =
        inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };

    programs.hyprlock.enable = true;
    security.pam.services.hyprland.enableGnomeKeyring = true;

    environment.sessionVariables = {
      # Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
      # Enable compatibility between the EGL API and the Wayland protocol
      egl-wayland

      # App launcher
      rofi

      # Authentication
      hyprpolkitagent
    ];

    # Hyprland in nixos by default will use xdg-desktop-portal-hyprland for its
    # portalPackage. This is here because the hyprland portal does not provide
    # a file picker, so we ensure gtk is available as a fallback
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
