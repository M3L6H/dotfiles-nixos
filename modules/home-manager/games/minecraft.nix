{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    games.minecraft.enable = mkEnableOption "enables minecraft module";
  };

  config =
    let
      # Prismlauncher theme
      prismlauncher-kanagawa = pkgs.stdenv.mkDerivation {
        name = "prismlauncher-kanagawa";

        src = pkgs.fetchzip {
          url = "https://github.com/PrismLauncher/Themes/releases/latest/download/Kanagawa-theme.zip";
          hash = "sha256-MV05AlnEh0tfSlZvoOgohH85djX+rkY/uTB4BtCaCEI=";
        };

        installPhase = ''
          mkdir -p "$out/prismlauncher-kanagawa"
          cp -a ./Kanagawa/. "$out/prismlauncher-kanagawa"
        '';
      };
    in
    mkIf config.games.minecraft.enable {
      wayland.windowManager =
        optionalAttrs config.hyprland.enable {
          hyprland.settings = {
            window_rule = [
              {
                name = "PrismLauncher";
                match = {
                  class = "org.prismlauncher.*";
                };
                workspace = "5";
              }
              {
                name = "Minecraft";
                match = {
                  class = "Minecraft.*";
                };
                workspace = "5";
              }
            ];
          };
        }
        // optionalAttrs config.mango.enable {
          mango.settings = {
            window_rule = [
              "tags:9,app_id:org.prismlauncher.PrismLauncher"
            ];
          };
        };

      home = {
        packages = with pkgs; [
          prismlauncher
          prismlauncher-kanagawa
        ];

        file.".local/share/PrismLauncher/themes/kanagawa" = {
          source = "${prismlauncher-kanagawa}/prismlauncher-kanagawa";
        };
      }
      // optionalAttrs config.impermanence.enable {
        persistence."/persist".directories = [
          ".local/share/PrismLauncher"
        ];
      };
    };
}
