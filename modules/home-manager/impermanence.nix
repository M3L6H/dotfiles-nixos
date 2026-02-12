{
  config,
  lib,
  ...
}:
{
  options = {
    impermanence.enable = lib.mkEnableOption "enables impermanence module";
  };

  config = lib.mkIf config.impermanence.enable {
    home.persistence."/persist" = {
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
}
