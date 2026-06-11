{
  config,
  lib,
  username,
  ...
}:
with lib;
{
  config = mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          {
            _args = [
              "SUPER + F"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.terminal.emulator}\")")
              { description = "Launch terminal"; }
            ];
          }
          {
            _args = [
              "SUPER + D"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"vivaldi\")")
              { description = "Launch browser"; }
            ];
          }
          {
            _args = [
              "SUPER + Space"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"rofi -show drun -run-command 'uwsm app -- {cmd}'\")")
              { description = "Launch app"; }
            ];
          }
          {
            _args = [
              "SUPER + Q"
              (generators.mkLuaInline "hl.dsp.window.close()")
              { description = "Close window"; }
            ];
          }
          {
            _args = [
              "SUPER + ALT + Q"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprlock\")")
              { description = "Lock computer"; }
            ];
          }
          {
            _args = [
              "SUPER + H"
              (generators.mkLuaInline "hl.dsp.focus({ direction = \"l\"})")
              { description = "Move focus left"; }
            ];
          }
          {
            _args = [
              "SUPER + J"
              (generators.mkLuaInline "hl.dsp.focus({ direction = \"d\"})")
              { description = "Move focus down"; }
            ];
          }
          {
            _args = [
              "SUPER + K"
              (generators.mkLuaInline "hl.dsp.focus({ direction = \"u\"})")
              { description = "Move focus up"; }
            ];
          }
          {
            _args = [
              "SUPER + L"
              (generators.mkLuaInline "hl.dsp.focus({ direction = \"r\"})")
              { description = "Move focus right"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + H"
              (generators.mkLuaInline "hl.dsp.window.move({ direction = \"l\"})")
              { description = "Move window left"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + J"
              (generators.mkLuaInline "hl.dsp.window.move({ direction = \"d\"})")
              { description = "Move window down"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + K"
              (generators.mkLuaInline "hl.dsp.window.move({ direction = \"u\"})")
              { description = "Move window up"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + L"
              (generators.mkLuaInline "hl.dsp.window.move({ direction = \"r\"})")
              { description = "Move window right"; }
            ];
          }
          {
            _args = [
              "SUPER + ALT + H"
              (generators.mkLuaInline "hl.dsp.window.resize({ x = -50, y = 0, relative = true})")
              { description = "Shrink window horizontally"; }
            ];
          }
          {
            _args = [
              "SUPER + ALT + J"
              (generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = 50, relative = true})")
              { description = "Grow window vertically"; }
            ];
          }
          {
            _args = [
              "SUPER + ALT + K"
              (generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = -50, relative = true})")
              { description = "Shrink window vertically"; }
            ];
          }
          {
            _args = [
              "SUPER + ALT + L"
              (generators.mkLuaInline "hl.dsp.window.resize({ x = 50, y = 0, relative = true})")
              { description = "Grow window horizontally"; }
            ];
          }
          {
            _args = [
              "SUPER + 1"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 1 })")
              { description = "Focus workspace 1"; }
            ];
          }
          {
            _args = [
              "SUPER + 2"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 2 })")
              { description = "Focus workspace 2"; }
            ];
          }
          {
            _args = [
              "SUPER + 3"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 3 })")
              { description = "Focus workspace 3"; }
            ];
          }
          {
            _args = [
              "SUPER + 4"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 4 })")
              { description = "Focus workspace 4"; }
            ];
          }
          {
            _args = [
              "SUPER + 5"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 5 })")
              { description = "Focus workspace 5"; }
            ];
          }
          {
            _args = [
              "SUPER + 6"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 6 })")
              { description = "Focus workspace 6"; }
            ];
          }
          {
            _args = [
              "SUPER + 7"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 7 })")
              { description = "Focus workspace 7"; }
            ];
          }
          {
            _args = [
              "SUPER + 8"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 8 })")
              { description = "Focus workspace 8"; }
            ];
          }
          {
            _args = [
              "SUPER + 9"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 9 })")
              { description = "Focus workspace 9"; }
            ];
          }
          {
            _args = [
              "SUPER + 0"
              (generators.mkLuaInline "hl.dsp.focus({ workspace = 0 })")
              { description = "Focus workspace 0"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 1"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 1, follow = true })")
              { description = "Move window to workspace 1"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 2"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 2, follow = true })")
              { description = "Move window to workspace 2"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 3"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 3, follow = true })")
              { description = "Move window to workspace 3"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 4"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 4, follow = true })")
              { description = "Move window to workspace 4"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 5"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 5, follow = true })")
              { description = "Move window to workspace 5"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 6"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 6, follow = true })")
              { description = "Move window to workspace 6"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 7"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 7, follow = true })")
              { description = "Move window to workspace 7"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 8"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 8, follow = true })")
              { description = "Move window to workspace 8"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 9"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 9, follow = true })")
              { description = "Move window to workspace 9"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + 0"
              (generators.mkLuaInline "hl.dsp.window.move({ workspace = 0, follow = true })")
              { description = "Move window to workspace 0"; }
            ];
          }
          {
            _args = [
              "XF86AudioLowerVolume"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
              { description = "Volume down"; }
            ];
          }
          {
            _args = [
              "XF86AudioMute"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
              { description = "Toggle mute"; }
            ];
          }
          {
            _args = [
              "XF86AudioRaiseVolume"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+\")")
              { description = "Volume up"; }
            ];
          }
          {
            _args = [
              "XF86AudioPlay"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
              { description = "Toggle play"; }
            ];
          }
          {
            _args = [
              "XF86AudioPrev"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")")
              { description = "Previous track"; }
            ];
          }
          {
            _args = [
              "XF86AudioNext"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")")
              { description = "Next track"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + W"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"/home/${username}/.local/bin/choose-wallpaper.sh\")")
              { description = "Change wallpaper"; }
            ];
          }
        ];
      };
    };
  };
}
