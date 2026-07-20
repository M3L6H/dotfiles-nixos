{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    autoTheme.enable = mkEnableOption "enable auto theming";
  };

  config =
    let
      confRoot = ".config/matugen";

      mangoConf = ''
        [templates.mango]
        input_path = '~/${confRoot}/mango.conf'
        output_path = '~/.config/mango/colors.conf'
        post_hook = '>/dev/null 2>&1 mmsg dispatch reload_config'
      '';
    in
    mkIf config.autoTheme.enable {
      home.packages = with pkgs; [
        inputs.matugen.packages.${stdenv.hostPlatform.system}.default
      ];

      home.file."${confRoot}/config.toml".text = ''
        [config]

        ${if config.mango.enable then mangoConf else ""}
      '';

      home.file."${confRoot}/mango.conf".source = mkIf config.mango.enable ./mango.conf;
    };
}
