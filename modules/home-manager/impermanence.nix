{
  config,
  lib,
  ...
}:
{
  options = {
    impermanence.enable = lib.mkEnableOption "enables impermanence module";
  };

  config = {
    home = lib.optionalAttrs config.impermanence.enable {
      persistence."/persist" = {
        directories = [
          # Audio
          ".local/state/wireplumber"

          # keyrings
          ".local/share/keyrings"

          # ssh files
          ".ssh"
        ];

        files = [
          ".gitconfig"
        ];
      };
    };
  };
}
