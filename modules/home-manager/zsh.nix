{
  config,
  inputs,
  lib,
  ...
}:
{
  options = {
    zsh.enable = lib.mkEnableOption "enables zsh module";
    zsh.zoxide.enable = lib.mkEnableOption "enables zoxide";
  };

  imports = [
    inputs.m3l6h-zsh.homeModule
  ];

  config = lib.mkIf config.zsh.enable {
    m3l6h.zsh = {
      enable = true;
      impermanence.enable = true;
    };

    m3l6h.zsh.zoxide.enable = config.zsh.zoxide.enable;
  };
}
