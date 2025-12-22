{
  device,
  hostname,
  inputs,
  username,
  ...
}:
{
  imports = [
    ../common

    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  system.stateVersion = "24.05";

  boot = {
    kernelParams = [
      "resume_offset=533760" # Retrieved by running `btrfs inspect-internal map-swapfile -r /mnt/swap/swapfile`
    ];

    resumeDevice = device;
  };

  # Mounts
  fileSystems."/mnt/files" = {
    device = "/dev/disk/by-uuid/13fc2c6d-1aa9-48c6-980c-8717bf3871ed";
    fsType = "ext4";
    options = [
      "rw"
      "users" # Allow any user to mount and unmount
      "nofail" # Prevent the system from failing if the drive does not exist
      "exec" # Users implies noexec, so explicitly set exec
    ];
  };

  fileSystems."/home/${username}/files" = {
    device = "/mnt/files";
    options = [
      "bind"
      "rw"
      "nofail"
    ];
  };

  networking.hostName = "nixos";

  swapDevices = [
    {
      device = "/swapfile";
      size = 128 * 1024; # 128GB
    }
  ];

  # Enable ai module
  ai.enable = true;

  # Enable nvidia module
  nvidia.enable = true;

  # Sops
  sops.defaultSopsFile = ./secrets.yaml;

  # Home manager
  home-manager = {
    extraSpecialArgs = { inherit hostname inputs username; };
    users = {
      "${username}" = import ../../homes/${username}/home.nix;
    };
  };
}
