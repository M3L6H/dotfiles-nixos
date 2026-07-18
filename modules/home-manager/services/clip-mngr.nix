{
  config,
  lib,
  ...
}:
with lib;
{
  options = {
    services.clip-mngr.enable = mkEnableOption "enables clipboard manager (clipse) module";
  };

  config = mkIf config.services.clip-mngr.enable {
    services.clipse = {
      enable = true;
      settings = {
        maxHistory = 200;
        imageDisplay = "kitty";
      };
      theme = {
        useCustomTheme = true;
        DimmedDesc = "#9e9b93";
        DimmedTitle = "#a6a69c";
        FilteredMatch = "#b6927b";
        NormalDesc = "#a99c8b";
        NormalTitle = "#8ba4b0";
        SelectedDesc = "#c4b28a";
        SelectedTitle = "#87a987";
        SelectedBorder = "#87a987";
        SelectedDescBorder = "#87a987";
        TitleFore = "#c5c9c5";
        Titleback = "#282727";
        StatusMsg = "#a292a3";
        PinIndicatorColor = "#c4746e";
      };
    };

    wayland.windowManager = mkIf config.hyprland.enable {
      hyprland.settings = {
        bind = [
          {
            _args = [
              "SUPER + SHIFT + C"
              (generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.terminal.emulator} --class=com.example.clipse -e 'clipse'\")")
              { description = "Launch clip mngr"; }
            ];
          }
        ];
        window_rule = [
          {
            name = "Clip Mngr";
            match = {
              class = "com.example.clipse";
            };
            float = true;
            size = [
              "622"
              "652"
            ];
          }
        ];
      };
    };

    home = optionalAttrs config.impermanence.enable {
      persistence."/persist".directories = [
        ".config/clipse"
      ];
    };
  };
}
