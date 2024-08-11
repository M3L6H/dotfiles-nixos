{ config, lib, ... }: {
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        "$mainMod" = "SUPER";
        bind = [
          "$mainMod, F, exec, kitty"
          "$mainMod, D, exec, firefox"
          "$mainMod, Space, exec, rofi -show run"
          "$mainMod, Q, killactive,"
          "$mainMod ALT, L, exec, hyprlock"
          "$mainMod SHIFT, Q, exit,"

          # Navigation
          "$mainMod, H, movefocus, l"
          "$mainMod, J, movefocus, d"
          "$mainMod, K, movefocus, u"
          "$mainMod, L, movefocus, r"

          # Window position
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, J, movewindow, d"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, L, movewindow, r"

          # Resize window
          "$mainMod ALT, H, resizeactive, -160 0"
          "$mainMod ALT, J, resizeactive, 0 160"
          "$mainMod ALT, K, resizeactive, 0 -160"
          "$mainMod ALT, L, resizeactive, 160 0"

          # Move windows between monitors
          "$mainMod ALT, 1, movewindow, mon:HDMI-A-1"
          "$mainMod ALT, 2, movewindow, mon:DP-1"
          "$mainMod ALT, 3, movewindow, mon:DP-2"

          # Focus monitors
          "$mainMod CTRL, 1, focusmonitor, HDMI-A-1"
          "$mainMod CTRL, 2, focusmonitor, DP-1"
          "$mainMod CTRL, 3, focusmonitor, DP-2"

          # Switch between workspaces
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 0"
          "$mainMod, bracketright, workspace, e+1"
          "$mainMod, bracketleft, workspace, e-1"

          # Move active window between workspaces
          "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
          "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
          "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
          "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
          "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
          "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
          "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
          "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
          "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
          "$mainMod SHIFT, 0, movetoworkspacesilent, 0"
          "$mainMod SHIFT, bracketright, movetoworkspacesilent, +1"
          "$mainMod SHIFT, bracketleft, movetoworkspacesilent, -1"

          # Dismiss notifications
          "$mainMod, M, exec, makoctl dismiss -a"
        ];
      };
    };
  };
}

