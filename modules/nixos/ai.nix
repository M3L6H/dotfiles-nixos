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
  };
}
