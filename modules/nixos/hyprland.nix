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
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };

    programs.hyprlock.enable = true;

    environment.sessionVariables = {
      # Hint electron apps to use wayland
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
      # Enable compatibility between the EGL API and the Wayland protocol
      egl-wayland

      # Notifications
      mako
      libnotify

      # Wallpaper engine
      mpvpaper # For video wallpapers
      swww

      # App launcher
      rofi

      # Authentication
      kdePackages.polkit-kde-agent-1
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Hyprland in nixos by default will use xdg-desktop-portal-hyprland for its
    # portalPackage. This is here because the hyprland portal does not provide
    # a file picker, so we ensure gtk is available as a fallback
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    security.polkit.enable = true;

    systemd.user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    systemd.user.services.swww-daemon = {
      description = "swww-daemon";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
