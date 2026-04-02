{
  config,
  inputs,
  lib,
  ...
}:
with lib;
{
  options = {
    zsh.enable = mkEnableOption "enables zsh module";
    zsh.zoxide.enable = mkEnableOption "enables zoxide";
  };

  imports = [
    inputs.m3l6h-zsh.homeModule
  ];

  config = mkIf config.zsh.enable {
    m3l6h.zsh = {
      enable = true;
      initContent = mkIf config.utils.direnv.enable ''
        eval "$(direnv hook zsh)"
      '';
      impermanence.enable = config.impermanence.enable;
      zoxide.enable = config.zsh.zoxide.enable;
    };
  };
}
