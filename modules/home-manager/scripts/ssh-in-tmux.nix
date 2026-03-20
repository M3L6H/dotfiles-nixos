{ config, lib, ... }:
{
  config = lib.mkIf config.impermanence.enable {
    home.file.".local/bin/ssh-in-tmux" = {
      executable = true;
      source = ./ssh-in-tmux.sh;
    };

    home.shellAliases.ssh = "$HOME/.local/bin/ssh-in-tmux";
  };
}
