{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.hyprland.enable {
    # Used to lock only if not in insomnia
    scripts.conditional-lock.enable = true;

    # Used to suspend only if not in insomnia
    scripts.conditional-suspend.enable = true;

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock --grace 60";
          before_sleep_cmd = "$HOME/.local/bin/conditional-lock";

          # To avoid having to press a key twice to turn on the display
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = "180";
            on-timeout = "$HOME/.local/bin/conditional-lock";
          }
          {
            timeout = "360";
            # Screen off when timeout has passed
            on-timeout = "hyprctl dispatch dpms off";
            # Screen on when activity is detected after timeout has fired
            on-resume = "hyprctl dispatch dpms on";
          }
          # {
          #   timeout = "1800";
          #   on-timeout = "$HOME/.local/bin/conditional-suspend"; # suspend pc
          # }
        ];
      };
    };
  };
}
