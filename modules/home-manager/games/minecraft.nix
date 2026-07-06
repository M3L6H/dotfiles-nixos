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
        name = "prismlauncher-tokyonight";

        src = pkgs.fetchurl {
          url = "https://github.com/PrismLauncher/Themes/releases/latest/download/Kanagawa-theme.zip";
          hash = "sha256-HabWPyWdPaQZAh/Ozhe8zAqvRwfnpDSjl9W+wydhaRI=";
        };

        nativeBuildInputs = [ pkgs.unzip ];

        installPhase = ''
          mkdir -p "$out/prismlauncher-kanagawa"
          cp -a ./Kanagawa/. "$out/prismlauncher-kanagawa"
        '';
      };
    in
    mkIf config.games.minecraft.enable {
      wayland.windowManager = mkIf config.hyprland.enable {
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
        persistence."/persist" = {
          directories = [
            ".local/share/PrismLauncher/assets"
            ".local/share/PrismLauncher/cache"
            ".local/share/PrismLauncher/catpacks"
            ".local/share/PrismLauncher/icons"
            ".local/share/PrismLauncher/iconthemes"
            ".local/share/PrismLauncher/java"
            ".local/share/PrismLauncher/libraries"
            ".local/share/PrismLauncher/logs"
            ".local/share/PrismLauncher/meta"
            ".local/share/PrismLauncher/skins"
            ".local/share/PrismLauncher/translations"
          ];

          files = [
            ".local/share/PrismLauncher/accounts.json"
            ".local/share/PrismLauncher/metacache"
            ".local/share/PrismLauncher/prismlauncher.cfg"
          ];
        };
      };
    };
}
