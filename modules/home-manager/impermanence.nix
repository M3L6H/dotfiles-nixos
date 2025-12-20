{
  config,
  inputs,
  lib,
  username,
  ...
}:
{
  options = {
    impermanence.enable = lib.mkEnableOption "enables impermanence module";
  };

  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  config = lib.mkIf config.impermanence.enable {
    home.persistence."/persist/home/${username}" = {
      directories = [
        # Audio
        {
          directory = ".local/state/wireplumber";
          method = "symlink";
        }

        # ssh files
        ".ssh"
      ];

      files = [
        ".gitconfig"
      ];

      allowOther = false;
    };
  };
}
