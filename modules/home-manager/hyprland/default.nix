{ config, lib, ... }:
{
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland module";
  };

  imports = [
    ./rofi
    ./binds.nix
    ./eww.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprshot.nix
    ./layer-rules.nix
    ./monitors.nix
    ./wallpaper.nix
    ./workspaces.nix
  ];

  config = lib.mkIf config.hyprland.enable {
    wallpaper.mpvpaper.enable = lib.mkDefault false;
    wallpaper.swww.enable = lib.mkDefault false;

    home.file.".config/electron-flags.conf".text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        # Taken from https://wiki.hyprland.org/Nvidia/#environment-variables
        env = [
          "LIBVA_DRIVER_NAME,nvidia"

          # Commenting these out as recommended by:
          # https://github.com/ValveSoftware/steam-for-linux/issues/9588#issuecomment-1648269150
          # "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          # "GBM_BACKEND,nvidia-drm" # Remove this if firefox crashes
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPQ_PLATFORM,wayland;xcb"

          "ELECTRON_OZONE_PLATFORM_HINT,wayland"

          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
        ];

        general = {
          border_size = "0";
          gaps_out = "10";
          # Keeping in case I decide to turn border back on
          "col.inactive_border" = "rgba(00000000)";
          "col.active_border" = "rgb(87a987)";
          resize_on_border = "true";
        };

        decoration = {
          rounding = "10";
          dim_inactive = "true";
          dim_strength = "0.2";

          blur = {
            enabled = "true";
            size = "16";
            passes = "2";
          };
        };

        misc = {
          focus_on_activate = "false";
        };

        cursor = {
          # 0 - use hw cursors if possible
          # 1 - don't use hw cursors
          # 2 - auto (disable when tearing) (default)
          no_hardware_cursors = "0";

          hide_on_key_press = "true";
        };

        ecosystem = {
          no_update_news = "true";
          no_donation_nag = "true";
        };
      };

      systemd.enable = false;
    };
  };
}
