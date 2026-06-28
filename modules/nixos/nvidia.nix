{ config, lib, ... }: with lib;
{
  options = {
    nvidia.enable = mkEnableOption "enables nvidia module";
  };

  config = mkIf config.nvidia.enable {
    # Use proprietary drivers
    nixpkgs.config.allowUnfree = true;

    environment.sessionVariables = {
      VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
    };

    boot.kernelParams = [
      # For suspend/wakeup
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"

      # Trying to fix "NVK requires nouveau"
      "nvidia-drm.fbdev=1"
    ];

    # Load nvidia driver for xorg and wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      # Enable OpenGL
      graphics = {
        enable = true;

        # Install 32-bit drivers for 32-bit apps such as Wine
        enable32Bit = true;
      };

      nvidia = {
        # Most wayland compositors need this
        modesetting.enable = true;

        # Enable Nvidia settings menu
        nvidiaSettings = true;

        # Nvidia driver
        package = mkDefault config.boot.kernelPackages.nvidiaPackages.stable;

        # For suspend/wakeup
        powerManagement = {
          enable = true;
        };

        # Disable open-dkms due to this bug: https://github.com/NVIDIA/open-gpu-kernel-modules/issues/472
        open = mkDefault false;
      };
    };
  };
}
