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

      quickshellConf = ''
        [templates.quickshell]
        input_path = '~/${confRoot}/quickshell.json'
        output_path = '~/.local/state/quickshell/generated/colors.json'
        post_hook = 'systemctl --user restart quickshell'
      '';

      rofiConf = ''
        [templates.rofi]
        input_path = '~/${confRoot}/rofi.rasi'
        output_path = '~/.config/rofi/colors.rasi'
      '';

      tmuxConf = ''
        [templates.tmux]
        input_path = '~/${confRoot}/tmux.conf'
        output_path = '~/.config/tmux/generated.conf'
        post_hook = 'tmux source-file ~/.config/tmux/generated.conf'
      '';
    in
    mkIf config.autoTheme.enable {
      home.packages = with pkgs; [
        inputs.matugen.packages.${stdenv.hostPlatform.system}.default
      ];

      home.file = mkMerge [
        {
          "${confRoot}/config.toml".text = ''
            [config]

            ${makoConf}
            ${if config.mango.enable then mangoConf else ""}
            ${if config.quickshell.enable then quickshellConf else ""}
            ${if config.rofi.enable then rofiConf else ""}
            ${if config.tmux.enable then tmuxConf else ""}
          '';
        }
        {
          "${confRoot}/mako".source = ./templates/mako;
        }

        (mkIf config.mango.enable {
          "${confRoot}/mango.conf".source = ./templates/mango.conf;
        })

        (mkIf config.quickshell.enable {
          "${confRoot}/quickshell.json".source = ./templates/quickshell.json;
        })

        (mkIf config.rofi.enable {
          "${confRoot}/rofi.rasi".source = ./templates/rofi.rasi;
        })

        (mkIf config.tmux.enable {
          "${confRoot}/tmux.conf".source = ./templates/tmux.conf;
        })
      ];
    };
}
