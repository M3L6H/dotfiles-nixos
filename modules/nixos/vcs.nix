{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    vcs.enable = lib.mkEnableOption "enables vcs module";
  };

  config =
    let
      gpg-no-cache = pkgs.writeShellScriptBin "gpg-no-cache" ''
        #! ${pkgs.bash}/bin/bash
        gpg-connect-agent "scd serialno" "learn --force" /bye 1> /dev/null 2> /dev/null
        gpg "$@"
      '';
    in
    lib.mkIf config.vcs.enable {
      environment.systemPackages = [
        gpg-no-cache
      ];

      programs.git = {
        enable = true;
        config = {
          user = {
            email = "8094643+M3L6H@users.noreply.github.com";
            name = "m3l6h";
            signingkey = "0x684A2EF7691E4FD3";
          };
          pull.rebase = true;
          init.defaultbranch = "main";
          rerere.enabled = true;
          column.ui = "auto";
          branch.sort = "comitterdate";
          gpg.program = "${gpg-no-cache}/bin/gpg-no-cache";
          commit.gpgsign = true;
          tag.gpgsign = true;
        };
      };
    };
}
