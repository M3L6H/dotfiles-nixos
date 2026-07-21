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

      makoConf = ''
        [templates.mako]
        input_path = '~/${confRoot}/mako'
        output_path = '~/.config/mako/mako-colors'
        post_hook = 'makoctl reload'
      '';

      mangoConf = ''
        [templates.mango]
        input_path = '~/${confRoot}/mango.conf'
        output_path = '~/.config/mango/colors.conf'
        post_hook = '>/dev/null 2>&1 mmsg dispatch reload_config'
      '';

      rofiConf = ''
        [templates.rofi]
        input_path = '~/${confRoot}/rofi.rasi'
        output_path = '~/.config/rofi/colors.rasi'
      '';
    in
    mkIf config.autoTheme.enable {
      home.packages = with pkgs; [
        inputs.matugen.packages.${stdenv.hostPlatform.system}.default
      ];

      home.file."${confRoot}/config.toml".text = ''
        [config]

        ${makoConf}
        ${if config.mango.enable then mangoConf else ""}
        ${if config.rofi.enable then rofiConf else ""}
      '';

      home.file."${confRoot}/mako".source = ./templates/mako;
      home.file."${confRoot}/mango.conf".source = mkIf config.mango.enable ./templates/mango.conf;
      home.file."${confRoot}/rofi.rasi".source = mkIf config.mango.enable ./templates/rofi.rasi;
    };
}
