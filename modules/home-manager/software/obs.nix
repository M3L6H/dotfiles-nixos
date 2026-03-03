{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    software.obs.enable = lib.mkEnableOption "enables obs module";
  };

  config = mkIf config.software.obs.enable {
    programs.obs-studio = {
      enable = true;

      # Nvidia hardware acceleration
      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };

    home = mkIf config.impermanence.enable {
      persistence."/persist".directories = [
        ".config/obs-studio"
      ];
    };

    wayland.windowManager.hyprland.settings.windowrule = mkIf config.hyprland.enable [
      "match:class com.obsproject.Studio, workspace 7"
    ];
  };
}
