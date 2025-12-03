{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options = {
    tmux.sessionx.enable = lib.mkEnableOption "enables tmux-sessionx plugin";
  };

  config = lib.mkIf config.tmux.sessionx.enable {
    utils.bat.enable = true; # Used for syntax highlighting in preview
    utils.fzf.enable = true; # Used for fuzzy finding
    zsh.zoxide.enable = true; # Used for zoxide mode

    programs.tmux.plugins = [
      {
        plugin = inputs.tmux-sessionx.packages.${pkgs.stdenv.hostPlatform.system}.default;
        extraConfig = ''
          set -g @sessionx-bind "o"
          set -g @sessionx-bind-tmuxinator-list "ctrl-t"

          set -g @sessionx-tmuxinator-mode "on"
          set -g @sessionx-zoxide-mode "on"
        '';
      }
    ];
  };
}
