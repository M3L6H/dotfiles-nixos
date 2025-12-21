{ username, ... }:
{
  imports = [
    ../../modules/home-manager/default.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
    shellAliases = {
      hms = "/home/${username}/.local/bin/home-manager-wrapper /etc/nixos#m3l6h";
      nxs = "/home/${username}/.local/bin/nix-rebuild-wrapper /etc/nixos#nixos";
    };
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

  # Still having memory issues :(
  wallpaper.mpvpaper.enable = false;

  # Enable swww wallpaper
  wallpaper.swww.enable = true;

  # Enable zsh
  zsh.enable = true;

  # Enable minecraft
  games.minecraft.enable = true;

  # Enable wallpaper haven script
  scripts.wallpaper-haven.enable = false;

  # Enable clipboard manager service
  services.clip-mngr.enable = true;

  # Enable bazecor
  software.bazecor.enable = false;

  # Enable digikam
  software.digikam.enable = false;

  # Enable freecad
  software.freecad.enable = true;

  # Enable krita
  software.krita.enable = false;

  # Enable obs
  software.obs.enable = true;

  # Enable obs
  software.prusa-slicer.enable = true;

  # Enable obs
  software.tag-studio.enable = true;

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
  utils.mesa-demos.enable = true;

  # Enable neovim-remote
  utils.nvr.enable = true;

  # Enable tealdeer
  utils.tealdeer.enable = true;

  # Enable unp util
  utils.unp.enable = true;

  # Enable wget
  utils.wget.enable = true;

  # Hyprland stuff
  wayland.windowManager.hyprland.settings = {
    "monitor" = [
      "DP-1, 1920x1080, 0x0, 1"
      "DP-2, 3840x2160, 1920x0, 2"
      "HDMI-A-1, 1920x1080, 3840x0, 1"
    ];
  };
}
