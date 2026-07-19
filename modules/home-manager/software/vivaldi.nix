{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    software.vivaldi.enable = mkEnableOption "enables vivaldi module";
  };

  config = mkIf config.software.vivaldi.enable {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (final: prev: {
        vivaldi =
          (prev.vivaldi.overrideAttrs (oldAttrs: {
            dontWrapQtApps = false;
            dontPatchELF = true;
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.kdePackages.wrapQtAppsHook ];
          })).override
            {
              commandLineArgs = ''
                --enable-features=UseOzonePlatform
                --ozone-platform=wayland
                --ozone-platform-hint=auto
                --enable-features=WaylandWindowDecorations
              '';
              enableWidevine = true;
              proprietaryCodecs = true;
            };
      })
    ];

    wayland.windowManager.mango.settings.bind = mkIf config.mango.enable [
      "SUPER,D,spawn,vivaldi"
    ];

    home = {
      packages = with pkgs; [
        vivaldi
      ];
    }
    // optionalAttrs config.impermanence.enable {
      persistence."/persist".directories = [
        ".config/vivaldi"
        ".local/lib/vivaldi"
      ];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "vivaldi-stable.desktop";
        "x-scheme-handler/http" = "vivaldi-stable.desktop";
        "x-scheme-handler/https" = "vivaldi-stable.desktop";
        "x-scheme-handler/about" = "vivaldi-stable.desktop";
        "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
      };
    };
  };
}
