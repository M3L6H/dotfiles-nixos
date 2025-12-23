{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  ...
}:
{
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
            name = "boot";
          };

          esp = {
            size = "512M";
            type = "EF00";
            name = "ESP";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
                "nodev"
                "nosuid"
                "noexec"
                "umask=0077"
              ];
            };
          };

          luks = {
            size = "100%";
            name = "nixos";
            content = {
              type = "luks";
              name = "root"; # Mapper name
              askPassword = true;
              settings = {
                crypttabExtraOpts = [
                  "fido2-device=auto"
                  "token-timeout=60"
                ];
              };
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f" # Force
                  "-L nixos" # Filesystem label
                ];

                # Create initial blank snapshot
                # Will later restore the root subvolume to this in order to clear it
                postCreateHook = ''
                  mount -o subvol=/ /dev/mapper/root /mnt
                  btrfs subvolume snapshot -r /mnt/@ /mnt/@-blank
                  umount /mnt
                '';

                subvolumes = {
                  # Root subvolume. Will be cleared on each reboot
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress-force=zstd"
                      "noatime"
                    ];
                  };

                  # Persistent data
                  "/@persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      "compress-force=zstd"
                      "noatime"
                      "nodev"
                      "nosuid"
                      "noexec"
                    ];
                  };

                  # Nix data
                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress-force=zstd"
                      "noatime"
                      "nodev"
                      "nosuid"
                    ];
                  };

                  # System logs
                  "/@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress-force=zstd"
                      "noatime"
                      "nodev"
                      "nosuid"
                      "noexec"
                    ];
                  };

                  # Swap
                  # Make sure to set boot.kernelParams.swap_offset based on
                  # https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
                  "/@swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "32G"; # Set this to the amount of RAM you have
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
