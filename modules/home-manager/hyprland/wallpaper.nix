{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  dir = "/home/${username}/files/images/wallpaper";
  image = "${dir}/wallpaper.jpg";
  video = "${dir}/wallpaper.mp4";
in
{
  options = {
    wallpaper.mpvpaper.enable = lib.mkEnableOption "enables mpvpaper wallpaper";
    wallpaper.swww.enable = lib.mkEnableOption "enables swww wallpaper";
  };

  config = {
    # Used to terminate mpvpaper
    utils.killall.enable = true;

    home.persistence."/persist/home/${username}" = lib.mkIf config.impermanence.enable {
      directories = [
        ".cache/swww"
      ];

      allowOther = false;
    };

    systemd.user.services.swww-init-wallpaper = lib.mkIf config.wallpaper.swww.enable {
      Unit = {
        Description = "swww-init-wallpaper";
        Wants = [ "swww-daemon.service" ];
        After = [ "swww-daemon.service" ];
      };
      Install = {
        WantedBy = [ "swww-daemon.service" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "swww-init-wallpaper" ''
          #!/run/current-system/sw/bin/bash

          ${pkgs.swww}/bin/swww img -t fade -o DP-1 ${image}
          sleep 1
          ${pkgs.swww}/bin/swww img -t fade -o HDMI-A-1 ${image}
          ${pkgs.swww}/bin/swww img -t fade -o DP-2 ${image}
          sleep 1
          ${pkgs.swww}/bin/swww img -t fade -o DP-2 ${image}
        ''}";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    systemd.user.services.mpvpaper-pre = {
      Unit = {
        Description = "mpvpaper-init-pre script for setting up mpvpaper service";
        Wants = [ "wayland-session.target" ];
        After = [
          "graphical-session.target"
          "wayland-session.target"
        ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "mpvpaper-init-pre" ''
          #!/run/current-system/sw/bin/bash

          sleep 2 # Delay to ensure Wayland is ready

          echo 'VIDEO=${video}' > "''${HOME}/.local/state/mpvpaper"
        ''}";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Taken from https://github.com/GhostNaN/mpvpaper/issues/101#issuecomment-3148527812
    systemd.user.services.mpvpaper = lib.mkIf config.wallpaper.mpvpaper.enable {
      Unit = {
        Description = "mpvpaper daemon for setting video wallpaper";
        Wants = [ "mpvpaper-pre.service" ];
        After = [ "mpvpaper-pre.service" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.writeShellScript "mpvpaper-init" ''
          #!/run/current-system/sw/bin/bash

          # Use gpu-api vulkan due to:
          # https://github.com/mpv-player/mpv/issues/15099#issuecomment-2413464065
          MPV_ARGS='--gpu-api=vulkan no-audio --loop-file=inf'

          mpvpaper -p -o "$MPV_ARGS" '*' "''${VIDEO:-${video}}"
        ''}";
        Restart = "on-failure";
        RestartSec = 5;
        # Don't block session startup
        StandardOutput = "null";
        StandardError = "journal";
        # Pass Wayland environment variables
        PassEnvironment = [
          "WAYLAND_DISPLAY"
          "HYPRLAND_INSTANCE_SIGNATURE"
        ];
        # Environment file
        EnvironmentFile = "/home/${username}/.local/state/mpvpaper";
      };
    };

    systemd.user.services.mpvpaper-check = {
      Unit = {
        Description = "Check mpvpaper memory usage & restart if needed";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "mpvpaper-memory" ''
          #!/run/current-system/sw/bin/bash

          THRESHOLD_MB=1024
          MONITOR_COMMAND="mpvpaper"

          rss_total_kb=$(ps -C "$MONITOR_COMMAND" -o rss= | awk '{sum += $1} END {print sum}')

          if [ -n "$rss_total_kb" ] && [ "$rss_total_kb" -gt 0 ]; then
              rss_total_mb=$(( rss_total_kb / 1024 ))

              if [ "$rss_total_mb" -gt "$THRESHOLD_MB" ]; then
                  echo "🚨 $MONITOR_COMMAND total RSS: ''${rss_total_mb}MB > ''${THRESHOLD_MB}MB. restarting mpvpaper..."
                  systemctl --user restart mpvpaper.service
              else
                  echo "✅ $MONITOR_COMMAND total RSS: ''${rss_total_mb}MB under the limit (''${THRESHOLD_MB}MB)."
              fi
          else
              echo "ℹ️ No process $MONITOR_COMMAND running."
          fi
        ''}";
      };
    };

    systemd.user.timers.mpvpaper-check = lib.mkIf config.wallpaper.mpvpaper.enable {
      Unit = {
        Description = "Run mpvpaper-check periodically";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        OnBootSec = "5min";
        OnUnitActiveSec = "5min";
        Persistent = true;
      };
    };

    home.file.".local/bin/choose-wallpaper.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh

        selection="$(ls ${dir} | rofi -dmenu)"

        # If we selected a specific wallpaper, then display it
        if [ -n "$selection" ]; then
          systemctl --user stop mpvpaper.service

          # If we selected a video wallpaper, use mpvpaper
          if [ "''${selection#*.}" = 'mp4' ]; then
            echo "VIDEO=${dir}/''${selection}" > "''${HOME}/.local/state/mpvpaper"
            systemctl --user start mpvpaper.service
          # Otherwise use swww
          else
            swww img -o DP-1 "${dir}/$selection"
            sleep 1
            swww img -o HDMI-A-1 "${dir}/$selection"
            sleep 1
            swww img -o DP-2 "${dir}/$selection"
          fi
        # Otherwise toggle between video and image wallpaper
        elif ! systemctl is-active --quiet --user mpvpaper.service; then
          systemctl --user start mpvpaper.service
        else
          systemctl --user stop mpvpaper.service
        fi
      '';
    };
  };
}
