{ lib, ... }:
with lib;
{
  imports = [
    ./autoTheme
    ./games
    ./hyprland
    ./mango
    ./notify
    ./rofi
    ./scripts
    ./services
    ./software
    ./toolchains
    ./utils

    ./aliases.nix
    ./gpg.nix
    ./impermanence.nix
    ./neovim.nix
    ./user-dirs.nix
    ./terminal.nix
    ./tmux.nix
    ./wallpaper.nix
    ./zsh.nix
  ];

  autoTheme.enable = mkDefault false;
  hyprland.enable = mkDefault false;
  mango.enable = mkDefault false;
  rofi.enable = mkDefault true;

  gpg.enable = mkDefault false;
  impermanence.enable = mkDefault true;
  neovim.enable = mkDefault false;
  user-dirs.enable = mkDefault false;
  terminal.enable = mkDefault false;
  tmux.enable = mkDefault false;
  zsh.enable = mkDefault false;
  zsh.zoxide.enable = mkDefault true;
}
