{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    utils.copilot.enable = lib.mkEnableOption "enables Copilot CLI";
  };

  config = lib.mkIf config.utils.copilot.enable {
    home = {
      packages = with pkgs; [
        github-copilot-cli
      ];
    }
    // lib.optionalAttrs config.impermanence.enable {
      persistence."/persist".directories = [
        ".copilot"
      ];
    };
  };
}
