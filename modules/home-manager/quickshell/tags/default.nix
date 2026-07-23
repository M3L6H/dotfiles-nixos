{ lib, ... }: with lib;
{
  options = {
    quickshell.tags.enable = mkEnableOption "Enable quickshell tags widget";
  };
}
