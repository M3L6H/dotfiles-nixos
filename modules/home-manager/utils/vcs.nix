{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    utils.vcs.enable = lib.mkEnableOption "enables vcs module";
    utils.vcs.settings = {
      commit.gpgsign = lib.mkOption {
        description = "Sign commits";
        default = true;
      };
      tag.gpgsign = lib.mkOption {
        description = "Sign tags";
        default = true;
      };
      user = lib.mkOption {
        description = "Passthrough user settings for git";
        default = {
          email = "8094643+M3L6H@users.noreply.github.com";
          name = "m3l6h";
          signingkey = "0x684A2EF7691E4FD3";
        };
      };
    };
  };

  config =
    let
      gpg-no-cache = pkgs.writeShellScriptBin "gpg-no-cache" ''
        #! ${pkgs.bash}/bin/bash
        gpg-connect-agent "scd serialno" "learn --force" /bye 1> /dev/null 2> /dev/null
        gpg "$@"
      '';
    in
    lib.mkIf config.utils.vcs.enable {
      home.packages = with pkgs; [
        git-crypt
        gpg-no-cache
        libsecret
      ];

      programs.git = {
        enable = true;
        package = pkgs.git.override { withLibsecret = true; };
        settings = {
          user = config.utils.vcs.settings.user;
          pull.rebase = true;
          init.defaultbranch = "main";
          rerere.enabled = true;
          column.ui = "auto";
          branch.sort = "comitterdate";
          gpg.program = "${gpg-no-cache}/bin/gpg-no-cache";
          commit.gpgsign = config.utils.vcs.settings.commit.gpgsign;
          tag.gpgsign = config.utils.vcs.settings.tag.gpgsign;

          # Credential settings
          credential.helper = "libsecret";
        };
      };
    };
}
