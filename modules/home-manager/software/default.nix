{ lib, ... }:
{
  imports = [
    ./digikam
    ./bazecor.nix
    ./firefox.nix
    ./krita.nix
    ./obs.nix
    ./prusa-slicer.nix
    ./vivaldi.nix
  ];

  software.digikam.enable = lib.mkDefault false;
  software.bazecor.enable = lib.mkDefault false;
  software.firefox.enable = lib.mkDefault false;
  software.krita.enable = lib.mkDefault false;
  software.obs.enable = lib.mkDefault false;
  software.prusa-slicer.enable = lib.mkDefault false;
  software.vivaldi.enable = lib.mkDefault false;
}
