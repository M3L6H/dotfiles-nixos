{
  device,
  hostname,
  inputs,
  username,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  system.stateVersion = "25.05";

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        useOSProber = true;
      };
    };

    kernelParams = [
      "resume_offset=533760" # Retrieved by running `btrfs inspect-internal map-swapfile -r /mnt/swap/swapfile`
    ];

    resumeDevice = device;

    initrd = {
      systemd = {
        enable = true;

        services.rollback = {
          description = "Nuke root & home subvolumes";
          wantedBy = [ "initrd.target" ];
          after = [ "systemd-cryptsetup@root.service" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir /btrfs_tmp

            mount -o subvol=/ /dev/mapper/root /btrfs_tmp

            delete_old_snapshots() {
              echo 'BEGIN delete_old_snapshots'
              seven_days_ago="$(date +%s -d '7 days ago')"
              echo "Seven days ago: $seven_days_ago"

              btrfs subvolume list -o "/btrfs_tmp" |
              cut -f 9- -d ' ' |
              cut -f 2- -d '-' |
              while read s; do date +%s -d "$s" >/dev/null 2>&1 && echo "$s"; done |
              head -n -7 |
              while read timestamp; do
                if [ "$(date +%s -d "$timestamp")" -lt "$seven_days_ago" ]; then
                  subvolume="@-$timestamp"
                  echo "Deleting $subvolume"
                  btrfs subvolume delete "/btrfs_tmp/$subvolume"
                fi
              done
              echo 'END delete_old_snapshots'
            }

            nuke_subvolume() {
              echo 'BEGIN nuke_subvolume'
              if [[ -e "/btrfs_tmp/$1" ]]; then
                btrfs subvolume list -o "/btrfs_tmp/$1" |
                cut -f 9- -d ' ' |
                while read subvolume; do
                  btrfs subvolume delete "/btrfs_tmp/$subvolume"
                done

                btrfs subvolume snapshot -r "/btrfs_tmp/$1" "/btrfs_tmp/$1-$(date +%FT%TZ)"

                btrfs subvolume delete "/btrfs_tmp/$1"
              fi

              btrfs subvolume snapshot "/btrfs_tmp/$1-blank" "/btrfs_tmp/$1"
              echo 'END nuke_subvolume'
            }

            delete_old_snapshots
            nuke_subvolume '@'

            sync

            umount /btrfs_tmp
          '';
        };
      };
    };
  };

  console = {
    earlySetup = true;
    keyMap = "us";
  };

  environment.etc.crypttab = {
    enable = true;
    text = ''
      files /dev/disk/by-uuid/b942d945-b599-48e1-8b9b-71235b725032 /root/keyfile luks
    '';
  };

  # Mounts
  fileSystems."/home/${username}/files" = {
    device = "/mnt/files";
    options = [
      "bind"
      "rw"
      "nofail"
    ];
  };

  nix.settings = {
    # Fix download buffer warnings
    # https://github.com/NixOS/nix/issues/11728
    download-buffer-size = 524288000;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  networking.hostName = "nixos-laptop";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "memlock";
      value = "infinity";
    }
  ];

  programs.fuse.userAllowOther = true;

  # Hide sudo lectures
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  # Enable ai module
  # ai.enable = true;

  # Enable hyprland module
  hyprland.enable = false;

  # Enable nvidia module
  nvidia.enable = false;

  # Impermanence for keyfile
  environment.persistence."/persist".files = [
    "/root/keyfile"
  ];

  # Home manager
  home-manager = {
    extraSpecialArgs = { inherit hostname inputs username; };
    users = {
      "${username}" = import ../../homes/${username}/home.nix;
    };
  };
}
