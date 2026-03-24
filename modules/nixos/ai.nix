{
  config,
  inputs,
  lib,
  ...
}:
{
  options = {
    ai.enable = lib.mkEnableOption "enables ai module";
    ai.openFirewall = lib.mkEnableOption "opens firewall for local network access";
  };

  imports = [
    inputs.m3l6h-ai.nixosModules.default
  ];

  config = lib.mkIf config.ai.enable {
    m3l6h.ai = {
      enable = true;
      extra-models = {
        enable = true;
        path = "extraModels.nix";
        rev = "fded33dccbfac75982b076bb1306dc536275ef96";
        url = "git@github.com:M3L6H/ai-extra.git";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf config.ai.openFirewall [ 8188 ];

    environment.shellAliases = {
      comfyui = "xdg-open http://localhost:8188";
      update-ai = "nix flake update m3l6h-ai";
    };

    systemd.services.comfyui.serviceConfig = {
      MemoryMax = "30G"; # Terminate ComfyUI if it reaches this point
      MemoryHigh = "24G"; # Start using swap
      OOMScoreAdjust = -1000; # Protect ComfyUI from the OOM killer
    };

    system.activationScripts = lib.mkIf config.impermanence.enable {
      "createPersistentStorageDirs".deps = [
        "var-lib-private-permissions"
        "users"
        "groups"
      ];

      "var-lib-private-permissions" = {
        deps = [ "specialfs" ];
        text = ''
          mkdir -p /persist/var/lib/private
          chmod 0700 /persist/var/lib/private
        '';
      };
    };

    environment.persistence."/persist" = lib.mkIf config.impermanence.enable {
      directories = [
        {
          directory = "/var/lib/private/comfyui"; # ComfyUI state
          mode = "0700";
        }
      ];
    };
  };
}
