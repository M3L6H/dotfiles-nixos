{
  config,
  hostname,
  inputs,
  lib,
  username,
  ...
}:
let
  colorscheme = "kanagawa";
in
{
  options = {
    neovim.enable = lib.mkEnableOption "Enable neovim";
  };

  imports = [
    inputs.m3l6h-neovim.homeModule
  ];

  config = lib.mkIf config.neovim.enable {
    home = {
      # Tone down nixd logs
      sessionVariables.NIXD_FLAGS = "-log=error";
    }
    // lib.optionalAttrs config.impermanence.enable {
      persistence."/persist".directories = [
        ".config/github-copilot"
        ".local/share/nvim"
        ".local/state/nvim"
        ".vim/undodir"
      ];
    };

    m3l6h.neovim = {
      enable = true;

      categoryDefinitions.merge =
        { pkgs, ... }:
        {
          startupPlugins = {
            colorscheme = [
              pkgs.vimPlugins."${colorscheme}-nvim"
            ];
          };
        };

      packageDefinitions.merge = {
        neovim =
          { pkgs, ... }:
          {
            settings = {
              inherit colorscheme;

              aliases = [
                "nvim"
              ]
              ++ lib.optionals (config.utils.nvr.enable) [
                "v"
                "vi"
                "vim"
              ];

              unwrappedCfgPath = "${config.home.homeDirectory}/.local/state/nvim/lazy";
            };

            categories = {
              colorscheme = true;
            };

            extra = {
              nixdExtras.nixpkgs = ''import (builtins.getFlake "path:${toString inputs.self}").inputs.nixpkgs {}'';
              nixdExtras.nixos_options = ''(builtins.getFlake "path:${toString inputs.self}").nixosConfigurations.${hostname}.options'';
              nixdExtras.home_manager_options = ''(builtins.getFlake "path:${toString inputs.self}").homeConfigurations.${username}.options'';

              nixdExtras.nvim_lspconfig = "${pkgs.vimPlugins.nvim-lspconfig}";
              nixdExtras.sqlite3_path = "${pkgs.sqlite.out}/lib/libsqlite3.so";
            };
          };
      };
    };
  };
}
