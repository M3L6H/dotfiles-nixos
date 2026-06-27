{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    gpg.enable = mkEnableOption "enables gpg module";
  };

  config = mkIf config.gpg.enable {
    home = {
      packages = with pkgs; [
        pinentry-qt
      ];
    }
    // optionalAttrs config.impermanence.enable {
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
      pinentry.package = pkgs.pinentry-curses;
      enableExtraSocket = true;
    };

    # Force-disable the default user sockets so they don't block your forwarded tunnel
    systemd.user.services.gpg-agent.Unit.RefuseManualStart = mkForce false;
  };
}
