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
    home.packages = with pkgs; [
      pinentry-qt
    ];

    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
    };

    home.persistence."/persist".directories = lib.mkIf config.impermanence.enable [
      ".gnupg"
    ];
  };
}
