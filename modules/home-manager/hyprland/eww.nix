{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hyprland.enable {
    # We use jq for parsing the output of hyprctl
    utils.jq.enable = true;
    # We use socat to listen to IPC sockets
    utils.socat.enable = true;

    home.packages = with pkgs; [
      eww
    ];

    home.file."${config.xdg.configHome}/eww" = {
      source = ./eww;
      recursive = true;
    };
  };
}
