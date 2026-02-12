{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    games.minecraft.enable = lib.mkEnableOption "enables minecraft module";
  };

  config =
    let
      # Prismlauncher theme
      prismlauncher-kanagawa = pkgs.stdenv.mkDerivation {
        name = "prismlauncher-tokyonight";

        src = pkgs.fetchurl {
          url = "https://github.com/PrismLauncher/Themes/releases/latest/download/Kanagawa-theme.zip";
          hash = "sha256-6NIwXhKJiWFLqRkWXmiSmlHutQmeXflIlmj7jOiD1bY=";
        };

        nativeBuildInputs = [ pkgs.unzip ];

        installPhase = ''
          mkdir -p "$out/prismlauncher-kanagawa"
          cp -a ./Kanagawa/. "$out/prismlauncher-kanagawa"
        '';
      };
    in
    lib.mkIf config.games.minecraft.enable {
      home.packages = with pkgs; [
        prismlauncher
        prismlauncher-kanagawa
      ];

      home.file.".local/share/PrismLauncher/themes/kanagawa" = {
        source = "${prismlauncher-kanagawa}/prismlauncher-kanagawa";
      };

      home.persistence."/persist" = lib.mkIf config.impermanence.enable {
        directories = [
          ".local/share/PrismLauncher/assets"
          ".local/share/PrismLauncher/cache"
          ".local/share/PrismLauncher/catpacks"
          ".local/share/PrismLauncher/icons"
          ".local/share/PrismLauncher/instances"
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
}
