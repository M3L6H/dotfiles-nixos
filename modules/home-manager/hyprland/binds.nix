{
  config,
  lib,
  username,
  ...
}:
with lib;
{
  config = mkIf config.hyprland.enable {
    home.file.".local/bin/binds" = {
      executable = true;
      source = ./binds.sh;
    };

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
              "SUPER + CTRL + Q"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"hyprlock\")")
              { description = "Lock computer"; }
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + F"
              (generators.mkLuaInline "hl.dsp.window.fullscreen({ mode = \"fullscreen\", action = \"toggle\"})")
              { description = "Toggle fullscreen"; }
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
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = toString i;
            in
            [
              {
                _args = [
                  "SUPER + ${ws}"
                  (generators.mkLuaInline "hl.dsp.focus({ workspace = ${ws} })")
                  { description = "Focus workspace ${ws}"; }
                ];
              }
              {
                _args = [
                  "SUPER + SHIFT + ${ws}"
                  (generators.mkLuaInline "hl.dsp.window.move({ workspace = ${ws}, follow = true })")
                  { description = "Move window to workspace ${ws}"; }
                ];
              }
            ]
          ) 9
        ))
        ++ [
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
              "SUPER + SHIFT + B"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"/home/${username}/.local/bin/binds\")")
              { description = "Search key binds"; }
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
