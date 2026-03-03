{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    gpg.enable = lib.mkEnableOption "enables gpg module";
  };

  config = lib.mkIf config.gpg.enable {
    home = {
      packages = with pkgs; [
        pinentry-qt
      ];
    }
    // lib.optionalAttrs config.impermanence.enable {
      persistence."/persist".directories = [
        ".gnupg"
      ];
    };

    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
    };
  };
}
