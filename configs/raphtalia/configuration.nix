{
  config,
  device,
  hostname,
  inputs,
  nixos-hardware,
  username,
  ...
}:
{
  imports = [
    nixos-hardware.nixosModules.dell-inspiron-7559

    ../common

    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  system.stateVersion = "25.05";

  boot = {
    kernelParams = [
      "acpi_backlight=native"
      "resume_offset=533760" # Retrieved by running `btrfs inspect-internal map-swapfile -r /mnt/swap/swapfile`
    ];

    resumeDevice = device;
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
    fsType = "auto";
    options = [
      "bind"
      "rw"
      "nofail"
    ];
  };

  networking.hostName = hostname;

  # Enable bluetooth module
  bluetooth.enable = true;

  # Enable hyprland module
  hyprland.enable = false;

  # Enable mango module
  mango.enable = true;

  # Enable nvidia module
  nvidia.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

  environment = {
    # Impermanence
    persistence."/persist" = {
      directories = [
        "/etc/NetworkManager"
        "/var/lib/NetworkManager"
      ];
      files = [
        "/root/keyfile"
      ];
    };
  };

  # Laptop close
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  # Sops
  sops.defaultSopsFile = ./secrets.yaml;

  # Home manager
  home-manager = {
    extraSpecialArgs = { inherit hostname inputs username; };
    users = {
      "${username}" = import ../../homes/${hostname}/${username}.nix;
    };
  };
}
