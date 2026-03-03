{
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

  # Enable custom neovim flake
  neovim.enable = true;

  # Disable impermanence
  impermanence.enable = false;

  # Enable terminal
  terminal.enable = true;

  # Enable tmux
  tmux.enable = true;

  # Enable managed user dirs
  user-dirs.enable = true;

  # Still having memory issues :(
  wallpaper.mpvpaper.enable = false;

  # Enable swww wallpaper
  wallpaper.swww.enable = false;

  # Enable zsh
  zsh.enable = true;

  # Enable cpp toolchain
  toolchains.c-cpp.enable = true;

  # Enable markdown toolchain
  toolchains.markdown.enable = true;

  # Enable file util
  utils.file.enable = true;

  # Enable gh util
  utils.gh.enable = true;

  # Enable lsof util
  utils.lsof.enable = true;

  # Enable neovim-remote
  utils.nvr.enable = true;

  # Enable sysstat
  utils.sysstat.enable = true;

  # Enable tealdeer
  utils.tealdeer.enable = true;

  # Enable unp util
  utils.unp.enable = true;

  # Enable wget
  utils.wget.enable = true;
}
