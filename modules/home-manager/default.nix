{ lib, ... }:
{
  imports = [
    ./games
    ./hyprland
    ./scripts
    ./services
    ./software
    ./tmux
    ./toolchains
    ./utils

    ./aliases.nix
    ./gpg.nix
    ./impermanence.nix
    ./neovim.nix
    ./user-dirs.nix
    ./terminal.nix
    ./zsh.nix
  ];

  hyprland.enable = lib.mkDefault false;

  gpg.enable = lib.mkDefault false;
  impermanence.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault false;
  user-dirs.enable = lib.mkDefault false;
  terminal.enable = lib.mkDefault false;
  tmux.enable = lib.mkDefault false;
  zsh.enable = lib.mkDefault false;
}
