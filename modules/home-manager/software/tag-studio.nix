{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
{
  options = {
    software.tag-studio.enable = lib.mkEnableOption "enables Tag Studio module";
  };

  config = lib.mkIf config.software.tag-studio.enable {
    home.packages = [
      inputs.tagstudio.packages.${pkgs.stdenv.hostPlatform.system}.tagstudio
    ];

    home.persistence."/persist/home/${username}" = lib.mkIf config.impermanence.enable {
      directories = [
        ".config/TagStudio"
      ];

      allowOther = false;
    };
  };
}
