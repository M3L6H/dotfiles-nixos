{ lib, ... }:
with lib;
{
  imports = [
    ./services
    ./ssh

    ./ai.nix
    ./audio.nix
    ./bluetooth.nix
    ./caches.nix
    ./container-engine.nix
    ./fonts.nix
    ./keyring.nix
    ./hyprland.nix
    ./impermanence.nix
    ./mango.nix
    ./network.nix
    ./nix-ld.nix
    ./nixos-rebuild-ng.nix
    ./nvidia.nix
    ./partition-manager.nix
    ./pcscd.nix
    ./sddm.nix
    ./sops.nix
    ./users.nix
    ./vpn.nix
  ];

  config.ai.enable = mkDefault false;
  config.bluetooth.enable = mkDefault false;
  config.container-engine.enable = mkDefault true;
  config.hyprland.enable = mkDefault false;
  config.mango.enable = mkDefault false;
  config.impermanence.enable = mkDefault true;
  config.nix-ld.enable = mkDefault true;
  config.nixos-rebuild-ng.enable = mkDefault true;
  config.nvidia.enable = mkDefault false;
  config.partition-manager.enable = mkDefault false;
  config.pcscd.enable = mkDefault true;
  config.sddm.enable = mkDefault true;
  config.ssh.enable = mkDefault false;
  config.sops.enable = mkDefault true;
  config.users.enable = mkDefault true;
  config.vpn.enable = mkDefault true;
}
