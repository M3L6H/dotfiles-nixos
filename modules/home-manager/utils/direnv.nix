{
  config,
  lib,
  ...
}:
{
  options = {
    utils.direnv.enable = lib.mkEnableOption "enables direnv module";
  };

  config = lib.mkIf config.utils.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
