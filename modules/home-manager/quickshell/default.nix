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
    quickshell.enable = mkEnableOption "enable quickshell module";
  };

  config =
    let
      pkg = inputs.quickshell.packages.${system}.default;
      system = pkgs.stdenv.hostPlatform.system;
    in
    mkIf config.quickshell.enable {
      home.packages = with pkgs; [
        qt6.qttools
        qt6.qtbase.dev
        qt6.qtdoc
      ];

      programs.quickshell = {
        enable = true;
        package = pkg;

        systemd = {
          enable = true;
          target = mkIf config.mango.enable "mango-session.target";
        };
      };

      home.file.".config/quickshell" = {
        source = ./markup;
        recursive = true;
      };

      home.file.".local/state/quickshell/generated/defaultColors.json".source = ./defaultColors.json;

      wayland.windowManager = {
        mango.extraConfig = mkIf config.mango.enable ''
          keymode=common
          bind=SUPER,F23,spawn,qs ipc call listenerSvc setShowBadges true
          bind=NONE,F24,spawn,qs ipc call listenerSvc setShowBadges false

          keymode=default
          bind=SUPER,N,spawn,sh -c "mmsg dispatch setkeymode,network && qs ipc call networkSvc setPanelOpen true"

          keymode=network
          bind=NONE,Q,spawn,qs ipc call networkSvc toggleWifi
          bind=NONE,R,spawn,qs ipc call networkSvc listNetworks
          bind=NONE,Escape,spawn,sh -c "mmsg dispatch setkeymode,default && qs ipc call networkSvc setPanelOpen false"
          bind=NONE,Caps_Lock,spawn,sh -c "mmsg dispatch setkeymode,default && qs ipc call networkSvc setPanelOpen false"
        '';
      };
    };
}
