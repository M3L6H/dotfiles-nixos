{ pkgs, ... }:
{
  config = {
    services = {
      gnome.gnome-keyring.enable = true;
    };

    security = {
      pam.services.login.enableGnomeKeyring = true;
      polkit.enable = true;
      polkit.enablePkexecWrapper = true;
    };

    environment.systemPackages = with pkgs; [
      polkit_gnome
    ];

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
