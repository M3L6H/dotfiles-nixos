{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    utils.unp.enable = lib.mkEnableOption "enables unp module";
  };

  config = lib.mkIf config.utils.unp.enable {
    home.shellAliases.unrar = "unrar-free";
    home.packages = with pkgs; [
      p7zip # For unpacking 7z archives
      unrar-free # For unpacking rar archives
      unp # Super unpacker
      unzip # For unpacking zip archives
    ];
  };
}
