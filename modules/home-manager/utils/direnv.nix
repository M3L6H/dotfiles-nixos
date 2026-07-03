{
  config,
  lib,
  ...
}:
with lib;
{
  options = {
    utils.direnv.enable = mkEnableOption "enables direnv module";
  };

  config = mkIf config.utils.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    home = optionalAttrs config.impermanence.enable {
      persistence."/persist".directories = [
        ".local/share/direnv"
      ];
    };
  };
}
