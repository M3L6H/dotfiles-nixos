{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    mango.enable = mkEnableOption "enable mango compositor";
  };

  imports = with inputs; [
    mangowm.hmModules.mango
  ];

  config = mkIf config.mango.enable {
    home.packages = with pkgs; [
      phinger-cursors
    ];

    wayland.windowManager.mango = {
      enable = true;
      settings = {
        exec-once = [
          "nm-applet &"
          "systemctl --user reset-failed"
          "systemctl --user start mango-session.target"
        ];

        xkb_rules_options = "caps:escape";
        trackpad_natural_scrolling = 1;

        cursor_hide_timeout = 5;

        focus_cross_monitor = 1;
        exchange_cross_monitor = 1;

        borderpx = 2;

        cursor_size = 32;
        cursor_theme = "phinger-cursors-dark";

        blur = 1;
        blur_optimized = 1;
        blur_params = {
          radius = 5;
          num_passes = 2;
        };

        border_radius = 6;
        focused_opacity = 1.0;
        unfocused_opacity = 0.8;

        animation_type_open = "slide";
        animation_type_close = "zoom";
        layer_animation_type_open = "fade";
        layer_animation_type_close = "fade";

        bind = [
          "SUPER,H,focusdir,left"
          "SUPER,J,focusdir,down"
          "SUPER,K,focusdir,up"
          "SUPER,L,focusdir,right"

          "SUPER,R,reload_config"
          "SUPER,Q,killclient"
          "SUPER+SHIFT,Q,killclient,force"
          "SUPER+ALT+CTRL+SHIFT,Q,quit"

          "SUPER,Space,spawn,rofi -show drun"

          "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ];
      };
      systemd = {
        enable = true;
        extraCommands = [
          "systemctl --user reset-failed"
          "systemctl --user start mango-session.target"
        ];
      };
    };
  };
}
