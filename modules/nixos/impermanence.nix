{ config, lib, username, ... }: {
  options = {
    impermanence.enable = lib.mkEnableOption "enables impermanence module";
  };

  config = lib.mkIf config.impermanence.enable {
    # Required for boot
    fileSystems."/persist".neededForBoot = true;

    environment = {
      persistence."/persist" = {
        hideMounts = true;

        directories = [
          {
            # System config
            directory = "/etc/nixos";
            user = username;
            group = "users";
            mode = "0755";
          }
          "/var/lib/nixos" # NixOS state
        ];

        files = [
          "/etc/machine-id" # Machine ID for journalctl
        ];
      };
    };
  };
}

