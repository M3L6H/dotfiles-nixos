{ lib, ... }:
{
  imports = [
    ./services

    # ./ai.nix
    ./caches.nix
    ./fonts.nix
    ./hyprland.nix
    ./impermanence.nix
    ./nix-ld.nix
    ./nixos-rebuild-ng.nix
    ./nvidia.nix
    ./partition-manager.nix
    ./pcscd.nix
    ./sddm.nix
    ./users.nix
    ./vcs.nix
  ];

  # config.ai.enable = lib.mkDefault false;
  config.hyprland.enable = lib.mkDefault true;
  config.impermanence.enable = lib.mkDefault true;
  config.nix-ld.enable = lib.mkDefault true;
  config.nixos-rebuild-ng.enable = lib.mkDefault true;
  config.nvidia.enable = lib.mkDefault false;
  config.partition-manager.enable = lib.mkDefault false;
  config.pcscd.enable = lib.mkDefault true;
  config.sddm.enable = lib.mkDefault true;
  config.users.enable = lib.mkDefault true;
  config.vcs.enable = lib.mkDefault true;
}
