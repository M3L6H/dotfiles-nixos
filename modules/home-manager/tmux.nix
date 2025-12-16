{
  config,
  inputs,
  lib,
  ...
}:
with lib;
{
  options = {
    tmux.enable = lib.mkEnableOption "enables tmux module";
    tmux.sessionx.enable = lib.mkEnableOption "enables tmux-sessionx plugin";
    tmux.tmuxinator.enable = lib.mkEnableOption "enables tmuxinator util";
  };

  imports = [
    inputs.m3l6h-tmux.homeModule
  ];

  config = mkIf config.tmux.enable {
    tmux.sessionx.enable = mkDefault true;
    tmux.tmuxinator.enable = mkDefault true;

    m3l6h.tmux = {
      enable = true;
      impermanence.enable = true;
      sessionx.enable = config.tmux.sessionx.enable;
      tmuxinator.enable = config.tmux.tmuxinator.enable;
    };
  };
}
