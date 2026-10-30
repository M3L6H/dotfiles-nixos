{ lib, ... }:
{
  imports = [
    ./minecraft.nix
    ./steam.nix
  ];

  config = {
    games.minecraft.enable = lib.mkDefault false;
    games.steam.enable = lib.mkDefault false;
  };
}
