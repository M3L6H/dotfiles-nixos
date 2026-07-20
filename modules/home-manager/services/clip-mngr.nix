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
        keyBindings = {
          down = "alt+j";
          up = "alt+k";
        };
        imageDisplay = {
          type = "kitty";
        };
        autoPaste = {
          enabled = true;
        };
      };
      theme = {
        useCustomTheme = false;
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

    wayland.windowManager = {
      hyprland.settings = mkIf config.hyprland.enable {
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

      mango.settings = mkIf config.mango.enable {
        bind = [
          "SUPER+SHIFT,C,spawn,${config.terminal.emulator} --class=com.example.clipse -e 'clipse'"
        ];
        windowrule = [
          "isfloating:1,width:622,height:652,appid:com.example.clipse"
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
