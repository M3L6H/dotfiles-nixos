{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  options = {
    utils.nvr.enable = lib.mkEnableOption "enables neovim-remote module";
  };

  config = lib.mkIf config.utils.nvr.enable {
    home.packages = with pkgs; [
      neovim-remote
    ];

    home.file.".local/bin/nvr-wrapper.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh

        # This script assumes we always want neovim running in the first tmux window
        # It also assumes that window is index 1

        NVIM_CMD="nvim --listen ''${NEOVIM_SOCKET:=/tmp/nvimsocket}"
        IS_TMUX="$([ "$TERM_PROGRAM" = 'tmux' ] && echo 'true' || echo 'false')"
        CUR_WIN="$(tmux display-message -p '#{window_index}')"

        if ! lsof "$NEOVIM_SOCKET" >/dev/null 2>&1; then
          if "$IS_TMUX" && [ "$CUR_WIN" != '1' ]; then
            tmux send-keys -t "$(tmux display-message -p '#S'):1" "$NVIM_CMD" Enter
            while ! lsof "$NEOVIM_SOCKET" >/dev/null 2>&1; do true; done
          fi
        fi

        nvr -s --servername "$NEOVIM_SOCKET" --remote "$@" \
        && if "$IS_TMUX"; then tmux select-window -t 1; fi
      '';
    };

    home.shellAliases.v = "/home/${username}/.local/bin/nvr-wrapper.sh";
    home.shellAliases.vi = "/home/${username}/.local/bin/nvr-wrapper.sh";
    home.shellAliases.vim = "/home/${username}/.local/bin/nvr-wrapper.sh";
  };
}
