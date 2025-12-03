{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    tmux.enable = lib.mkEnableOption "enables tmux module";
  };

  imports = [
    ./sessionx.nix
    ./tmuxinator.nix
  ];

  config = lib.mkIf config.tmux.enable {
    tmux.sessionx.enable = lib.mkDefault true;
    tmux.tmuxinator.enable = lib.mkDefault true;

    utils.playerctl.enable = true; # Used by playerctl plugin
    utils.wl-clipboard.enable = true; # Used by yank plugin

    programs.tmux = {
      enable = true;
      baseIndex = 1;

      extraConfig = ''
        # Shift-Alt- vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Reload tmux with PREFIX+r
        bind r source-file ~/.config/tmux/tmux.conf

        # Enter copy mode with Alt-v
        bind-key -n 'M-v' copy-mode

        # Disable confirmation for closing pane
        bind x kill-pane

        # Close all panes except current
        bind X kill-pane -a

        # Kill session
        bind Q confirm-before -p "kill-session #S? (y/n)" kill-session

        # Quick window jumping
        bind f select-window -t 1
        bind d select-window -t 2
        bind s select-window -t 3
        bind a select-window -t 4

        # Proper vim select
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle

        # Open panes in current directory
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"

        # Increase scrollback buffer size
        set-option -g history-limit 100000

        # Set status right length to handle playerctl
        set -g status-right-length 150

        # Disable detatch on destroy so we can easily close all tmux sessions
        set-option -g detach-on-destroy off

        # No auto renaming
        set-option -g allow-rename off
      '';

      keyMode = "vi";
      mouse = true;

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = kanagawa;
          extraConfig = ''
            set -g @kanagawa-theme dragon

            # Transparent background
            set -g @kanagawa-ignore-window-colors true

            # Powerline
            set -g @kanagawa-show-powerline true
            set-option -g status-position top

            # Plugins
            set -g @kanagawa-plugins ""
            set -g @kanagawa-military-time false
            set -g @kanagawa-left-icon "󱚝  #S"
            set -g @kanagawa-show-fahrenheit false
            set -g @kanagawa-show-location false
            set -g @kanagawa-show-timezone false
            set -g @kanagawa-show-empty-plugins false
            set -g @kanagawa-show-left-sep 
            set -g @kanagawa-show-right-sep 
          '';
        }
        sensible
        vim-tmux-navigator
        yank
      ];

      prefix = "M-Space"; # Set prefix to be Alt-Space
      shell = lib.mkIf config.zsh.enable "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
    };
  };
}
