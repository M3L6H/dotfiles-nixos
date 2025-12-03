{
  config,
  lib,
  username,
  ...
}:
{
  options = {
    services.clip-mngr.enable = lib.mkEnableOption "enables clipboard manager (clipse) module";
  };

  config = lib.mkIf config.services.clip-mngr.enable {
    services.clipse = {
      enable = true;
      historySize = 200;
      imageDisplay = {
        type = "kitty";
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

    wayland.windowManager.hyprland.settings = {
      bind = [
        "$mainMod SHIFT, C, exec, ${config.terminal.emulator} --class=com.example.clipse -e 'clipse'"
      ];

      windowrule = [
        "match:class com.example.clipse, float on"
        "match:class com.example.clipse, size 622 652"
      ];
    };

    home.persistence."/persist/home/${username}" = lib.mkIf config.impermanence.enable {
      directories = [
        ".config/clipse"
      ];

      allowOther = false;
    };
  };
}
