{
  config,
  lib,
  username,
  ...
}:
{
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        "$mainMod" = "SUPER";
        bind = [
          "$mainMod, F, exec, uwsm app -- ${config.terminal.emulator}"
          "$mainMod, D, exec, uwsm app -- vivaldi"
          "$mainMod, Space, exec, rofi -show drun -run-command \"uwsm app -- {cmd}\""
          "$mainMod, Q, killactive,"
          "$mainMod ALT, L, exec, uwsm app -- hyprlock"
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
          "$mainMod ALT SHIFT, H, resizeactive, -50 0"
          "$mainMod ALT SHIFT, J, resizeactive, 0 50"
          "$mainMod ALT SHIFT, K, resizeactive, 0 -50"
          "$mainMod ALT SHIFT, L, resizeactive, 50 0"

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

          # Media keys
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"

          # Toggle wallpaper
          "$mainMod SHIFT, W, exec, /home/${username}/.local/bin/choose-wallpaper.sh"
        ];
      };
    };
  };
}
