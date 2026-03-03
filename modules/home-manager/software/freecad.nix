{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    software.freecad.enable = lib.mkEnableOption "enables freecad module";
  };

  config = lib.mkIf config.software.freecad.enable {
    nixpkgs.overlays = [
      (final: prev: {
        freecad = prev.freecad.overrideAttrs (oldAttrs: {
          postInstall = (oldAttrs.postInstall or "") + ''
            wrapProgram $out/bin/FreeCAD --set QT_QPA_PLATFORM xcb
          '';
        });
      })
    ];

    home = {
      packages = with pkgs; [
        freecad
      ];
    }
    // lib.optionalAttrs config.impermanence.enable {
      persistence."/persist".directories = [
        ".config/FreeCAD"
        ".local/share/FreeCAD"
      ];
    };
  };
}
