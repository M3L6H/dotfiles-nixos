{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    software.vivaldi.enable = lib.mkEnableOption "enables vivaldi module";
  };

  config = lib.mkIf config.software.vivaldi.enable {
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

    home.packages = with pkgs; [
      vivaldi
    ];

    home.persistence."/persist".directories = lib.mkIf config.impermanence.enable [
      ".config/vivaldi"
      ".local/lib/vivaldi"
    ];

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
