{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  options = {
    users.enable = lib.mkEnableOption "enables users module";
    users.zsh.enable = lib.mkEnableOption "enables zsh as default shell";
  };

  config = lib.mkIf config.users.enable {
    users.zsh.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      home-manager
    ];

    programs.zsh.enable = config.users.zsh.enable;

    # Completion for system packages (e.g. systemd)
    environment.pathsToLink = lib.mkIf config.users.zsh.enable [ "/share/zsh" ];

    users.users."${username}" = {
      isNormalUser = true;
      description = "Michael Hollingworth";
      initialPassword = lib.mkIf (config.users.users."${username}".hashedPasswordFile == null) "0";
      extraGroups = [
        "dialout" # Allow access to serial device
        "networkmanager"
        "wheel" # Enable 'sudo' for the user
      ];
      shell = lib.mkIf config.users.zsh.enable pkgs.zsh;
    };
  };
}
