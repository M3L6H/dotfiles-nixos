{
  config,
  lib,
  username,
  ...
}:
{
  config = lib.mkIf config.hyprland.enable {
    home.file.".config/hypr/hyprlock.conf" =
      let
        monitor-1 = "DP-1";
        monitor-2 = "DP-2";
        monitor-3 = "HDMI-A-1";

        dir = "/home/${username}/files/images/wallpaper";
        image = "${dir}/lockscreen.jpg";
      in
      {
        text = ''
          general {
            hide_cursor = true
            ignore_empty_input = true
          }

          background {
            path = ${image}
            blur_passes = 3
            contrast = 1
            brightness = 0.75
            vibrancy = 0.2
            vibrancy_darkness = 0.2
          }

          label {
            monitor = ${monitor-1}
            text = <span foreground="##c5c9c5">Hello, <i>$USER</i></span>
            font_size = 36
            font_family = VictorMono Nerd Font
            position = 0, 0
            halign = center
            valign = center
          }

          label {
            monitor = ${monitor-2} 
            text = <span foreground="##c5c9c5">Enter password</span>
            font_size = 24
            font_family = VictorMono Nerd Font
            position = 0, 0
            halign = center
            valign = center
          }

          label {
            monitor = ${monitor-3} 
            text = cmd[update:1000] echo "<span foreground='##c5c9c5'>$(date +%r)</span>"
            font_size = 36
            font_family = VictorMono Nerd Font
            position = 0, 0
            halign = center
            valign = center
          }

          input-field {
            monitor = DP-2
            size = 250, 60
            outline_thickness = 2
            dots_size = 0.2
            dots_spacing = 0.35
            dots_center = true
            outer_color = rgba(13, 12, 12)
            inner_color = rgba(13, 12, 12, 0.2)
            font_color = rgb(197, 201, 197)
            font_family = VictorMono Nerd Font
            fade_on_empty = true
            rounding = -1
            check_color = rgb(185, 141, 123)
            placeholder_text = <i><span foreground="##625e5a">Password</span></i>
            hide_input = false
            position = 0, -75
            halign = center
            valign = center
          }
        '';
      };
  };
}
