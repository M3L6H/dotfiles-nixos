{
  config,
  inputs,
  lib,
  pkgs,
  username,
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
      home.packages =
        with pkgs;
        [
          qt6.qttools
          qt6.qtbase.dev
          qt6.qtdoc
        ]
        ++ optionals config.mango.enable [
          (writeShellApplication {
            name = "mango-open-network-panel";
            runtimeInputs = [
              jq
              mango
            ];
            text = ''
              mmsg dispatch setkeymode,network
              monitor="$(mmsg get all-monitors | jq -r '.monitors[] | select(.active) | .name')"
              qs ipc call networkSvc setPanelOpen "$monitor"
            '';
          })
          (writeShellApplication {
            name = "mango-close-network-panel";
            runtimeInputs = [
              mango
            ];
            text = ''
              mmsg dispatch setkeymode,default
              qs ipc call networkSvc setPanelOpen ""
            '';
          })
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

      home.file.".config/lockscreen" = {
        source = ./lockscreen;
        recursive = true;
      };

      home.file.".local/state/quickshell/generated/defaultColors.json".source = ./defaultColors.json;

      wayland.windowManager = {
        mango.extraConfig = mkIf config.mango.enable ''
          keymode=common
          bind=SUPER+CTRL,Q,spawn,qs -p /home/${username}/.config/lockscreen
          bind=SUPER,F23,spawn,qs ipc call listenerSvc setShowBadges true
          bind=NONE,F24,spawn,qs ipc call listenerSvc setShowBadges false

          keymode=default
          bind=SUPER,N,spawn,mango-open-network-panel

          keymode=network
          bind=NONE,Q,spawn,qs ipc call networkSvc toggleWifi
          bind=NONE,R,spawn,qs ipc call networkSvc listNetworks
          bind=NONE,Escape,spawn,mango-close-network-panel
          bind=NONE,Caps_Lock,spawn,mango-close-network-panel
          bind=SUPER,N,spawn,mango-close-network-panel
        '';
      };
    };
}
