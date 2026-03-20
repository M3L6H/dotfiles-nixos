{ lib, ... }:
{
  imports = [
    ./conditional-lock.nix
    ./conditional-suspend.nix
    ./fs-diff.nix
    ./home-manager-wrapper.nix
    ./nix-rebuild-wrapper.nix
    ./persist.nix
    ./ssh-in-tmux.nix
    ./toggle-mute.nix
    ./wallpaper-haven.nix
  ];

  config = {
    scripts.conditional-lock.enable = lib.mkDefault false;
    scripts.conditional-suspend.enable = lib.mkDefault false;
    scripts.wallpaper-haven.enable = lib.mkDefault false;

    home.sessionPath = [
      "$HOME/.local/bin"
    ];
  };
}
