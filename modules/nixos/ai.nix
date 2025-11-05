{
  config,
  inputs,
  lib,
  ...
}:
{
  options = {
    ai.enable = lib.mkEnableOption "enables ai module";
  };

  imports = [
    inputs.m3l6h-ai.nixosModules.default
  ];

  config = lib.mkIf config.ai.enable {
    m3l6h.ai.enable = true;

    environment.shellAliases = {
      comfyui = "xdg-open http://localhost:8188";
      update-ai = "nix flake update m3l6h-ai";
    };

    environment.persistence."/persist".directories = lib.mkIf config.impermanence.enable [
      "/var/lib/private/comfyui"
    ];
  };
}
