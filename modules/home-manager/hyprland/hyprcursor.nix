{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.phinger.homeManagerModules.hyprcursor-phinger
  ];

  config = lib.mkIf config.hyprland.enable {
    programs.hyprcursor-phinger.enable = true;

    wayland.windowManager.hyprland.settings.env = [
      "HYPRCURSOR_THEME,phinger-cursors-dark"
      "HYPRCURSOR_SIZE,24"
    ];
  };
}
