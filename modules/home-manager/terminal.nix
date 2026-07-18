{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = with lib; {
    terminal.enable = mkEnableOption "enables terminal module";
    terminal.emulator = mkOption {
      default = "ghostty";
      description = "
        Set the terminal emulator to use.
        Supported values:
         - ghostty
         - kitty
        ";
      type = with types; uniq str;
    };
  };

  config = lib.mkIf config.terminal.enable {
    home.packages = with pkgs; [
      nerd-fonts.victor-mono
    ];

    programs.ghostty = {
      enable = config.terminal.emulator == "ghostty";

      enableZshIntegration = true;

      settings = {
        font-family = "VictorMono Nerd Font";
        font-size = 10;
        theme = "Kanagawa Dragon";
        background-opacity = 0.85;
        scrollback-limit = 1073741824; # 1 GB in bytes
        keybind = [
          "ctrl+shift+t=unbind" # No need for terminal tabs with tmux :)
          "alt+1=unbind" # We don't use tabs
          "alt+2=unbind" # We don't use tabs
          "alt+3=unbind" # We don't use tabs
          "alt+4=unbind" # We don't use tabs
          "alt+5=unbind" # We don't use tabs
          "alt+6=unbind" # We don't use tabs
          "alt+7=unbind" # We don't use tabs
          "alt+8=unbind" # We don't use tabs
          "alt+9=unbind" # We don't use tabs
          "ctrl+v=paste_from_clipboard"
        ];
        copy-on-select = "clipboard";
        confirm-close-surface = "false";
      };
    };

    programs.kitty = {
      enable = config.terminal.emulator == "kitty";

      font = {
        package = pkgs.nerd-fonts.victor-mono;
        name = "VictorMono Nerd Font";
        size = 10;
      };

      settings = {
        # We use tmux for scrollback
        scrollback_lines = 0;

        # Copy to clipboard rather than private buffer
        copy_on_select = "clipboard";

        enable_audio_bell = false;
        confirm_os_window_close = 0;
        tab_bar_edge = "top";

        # Color scheme
        background_opacity = "0.85";
        background_tint = "0.98";

        # Kanagawa colors
        transparent_background_colors = "#12120f #16161D #181820 #1a1a22 #1F1F28 #2A2A37 #363646";

        # Required for dynamically changing the terminal background in kitty
        allow_remote_control = "${if config.scripts.wallpaper-haven.enable then "socket-only" else "no"}";
        listen_on = "${if config.scripts.wallpaper-haven.enable then "unix:/tmp/kitty" else "none"}";
      };

      themeFile = "kanagawa_dragon";
    };

    # Required for dynamically changing the terminal background in kitty
    home.sessionVariables.KITTY_LISTEN_ON = "${
      if config.terminal.emulator == "kitty" && config.scripts.wallpaper-haven.enable then
        "unix:/tmp/kitty"
      else
        "none"
    }";
  };
}
