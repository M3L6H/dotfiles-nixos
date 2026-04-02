{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    utils.direnv.enable = lib.mkEnableOption "enables direnv module";
  };

  config = lib.mkIf config.utils.direnv.enable {
    home.packages = with pkgs; [
      direnv
      nix-direnv
    ];
  };
}
