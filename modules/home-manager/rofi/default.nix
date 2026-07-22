{ config, lib, ... }: with lib;
{
  options = {
    rofi.enable = mkEnableOption "enable rofi";
  };

  config = mkIf config.rofi.enable {
    home.file.".local/bin" = {
      source = ./scripts;
      executable = true;
      recursive = true;
    };

    home.file.".local/bin/rofi-wallpaper.sh" =
      let
        autoThemeScript = ''
          confFile="''${selection%.*}.json"
          if ! [ -f "$confFile" ]; then
            matugen image "$selection" --json hex -t scheme-smart --prefer less-saturation > "$confFile"
          fi
          matugen json "$confFile"
          name="$(basename "$selection")"
          notify-send "Updated theme to ''${name%.*}"
        '';
      in
      {
        text = ''
          #!/usr/bin/env bash

          change_wp() {
            exec 0<&- # Close stdin
            exec >/dev/null 2>&1

            selection="$1"

            systemctl --user stop mpvpaper.service

            # If we selected a video wallpaper, use mpvpaper
            if [ "''${selection#*.}" = 'mp4' ]; then
              echo "VIDEO=$selection" > "''${HOME}/.local/state/mpvpaper"
              systemctl --user start mpvpaper.service
            # Otherwise use awww
            else
              for monitor in ${config.wallpaper.monitors}; do
                awww img -o "$monitor" --transition-type center "$selection"
                sleep 1
              done
              ${if config.autoTheme.enable then autoThemeScript else ""}
              echo "$selection" > "''${HOME}/.config/wallpaper/wallpaper"
              rm "''${HOME}/.config/wallpaper/lockscreen"
              ln -s "$selection" "''${HOME}/.config/wallpaper/lockscreen"
            fi
          }

          if [ -n "$1" ]; then
            (change_wp "$1") &
            disown $!

            exit 0
          fi

          shopt -s extglob

          first=true

          for f in ~/files/images/wallpaper/!(*.json); do
            [ -f "$f" ] || continue

            if "$first"; then
              rofi-preview.sh "$f"
              first=false
            fi

            name="$(basename "$f")"

            echo -ne "''${f}\0display\x1f''${name}\x1ficon\x1f''${f}\n"
          done
        '';

        executable = true;
      };

    home.file.".config/rofi/themes" = {
      source = ./themes;
      recursive = true;
    };

    home.file.".config/rofi/config.rasi" = {
      source = ./config.rasi;
    };

    wayland.windowManager.mango.settings.bind = mkIf config.mango.enable [
      "SUPER,Space,spawn,rofi -show drun"
    ];
  };
}
