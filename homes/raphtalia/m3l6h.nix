{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../modules/home-manager/default.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable GPG keys
  gpg.enable = true;

  # Enable management of hyprland through home-manager
  hyprland.enable = true;

  # Enable custom neovim flake
  neovim.enable = true;

  # Enable terminal
  terminal.enable = true;

  # Enable tmux
  tmux.enable = true;

  # Enable managed user dirs
  user-dirs.enable = true;

  # Lockscreen options
  lockscreen = {
    monitor-1 = "eDP-1";
  };

  # Still having memory issues :(
  wallpaper.mpvpaper.enable = false;

  # Enable swww wallpaper
  wallpaper.swww.enable = true;

  # Wallpaper init script
  wallpaper.initScript = "${pkgs.writeShellScript "swww-init-wallpaper" ''
    #!/run/current-system/sw/bin/bash

    sleep 2 # Delay to ensure Wayland is ready
    ${pkgs.swww}/bin/swww img -t fade -o eDP-1 "$(cat "''${HOME}/.config/wallpaper/wallpaper")"
  ''}";

  wallpaper.monitors = "eDP-1";

  # Enable zsh
  zsh.enable = true;

  # Enable minecraft
  games.minecraft.enable = false;

  # Enable clipboard manager service
  services.clip-mngr.enable = true;

  # Enable obs
  software.obs.enable = true;

  # Enable prusa-slicer
  software.prusa-slicer.enable = true;

  # Enable vivaldi
  software.vivaldi.enable = true;

  # Enable cpp toolchain
  toolchains.c-cpp.enable = true;

  # Enable markdown toolchain
  toolchains.markdown.enable = true;

  # Enable ffmpeg util
  utils.ffmpeg.enable = true;

  # Enable file util
  utils.file.enable = true;

  # Enable gh util
  utils.gh.enable = true;

  # Enable lsof util
  utils.lsof.enable = true;

  # Enable mesa-demos util
  utils.mesa-demos.enable = false;

  # Enable neovim-remote
  utils.nvr.enable = true;

  # Enable tealdeer
  utils.tealdeer.enable = true;

  # Enable unp util
  utils.unp.enable = true;

  # Enable wget
  utils.wget.enable = true;

  # Hyprland stuff
  wayland.windowManager.hyprland.settings.exec-once = [
    "eww open-many main-bar"
  ];
  wayland.windowManager.hyprland.settings = {
    "monitor" = [
      "eDP-1, 3840x2160, 0x0, 2"
    ];
  };
}
