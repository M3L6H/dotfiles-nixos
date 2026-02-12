{
  description = "My system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-24.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprcursor = {
      url = "git+https://github.com/hyprwm/hyprcursor?ref=refs%2Fheads%2Fmain";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?ref=refs%2Fheads%2Fmain&submodules=1";
    };
    hyprland-plugins = {
      url = "git+https://github.com/hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    m3l6h-ai = {
      url = "github:m3l6h/dotfiles-ai";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    m3l6h-neovim = {
      url = "github:m3l6h/dotfiles-neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    m3l6h-tmux = {
      url = "github:m3l6h/dotfiles-tmux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    m3l6h-zsh = {
      url = "github:m3l6h/dotfiles-zsh";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.impermanence.follows = "impermanence";
    };

    phinger = {
      url = "github:Jappie3/hyprcursor-phinger";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tagstudio = {
      url = "github:TagStudioDev/TagStudio";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tmux-sessionx.url = "github:omerxx/tmux-sessionx";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      flake-parts,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfree = true;
      };

      modules = [
        inputs.disko.nixosModules.default
        inputs.home-manager.nixosModules.default
        inputs.impermanence.nixosModules.impermanence
        inputs.sops-nix.nixosModules.sops
      ];

      my-systems = [
        {
          inherit inputs;
          hostname = "hanekawa";
          device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_4TB_S757NS0X302547W";
          username = "m3l6h";
        }
        {
          inherit inputs;
          hostname = "raphtalia";
          device = "/dev/disk/by-id/wwn-0x5002538700000000";
          username = "m3l6h";
        }
      ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ system ];

      flake = {
        # NixOS configuration entrypoint
        # Available through 'sudo nixos-rebuild switch --flake .#hostname'
        nixosConfigurations = builtins.listToAttrs (
          map (args: {
            name = args.hostname;
            value = nixpkgs.lib.nixosSystem {
              specialArgs = args;
              modules = modules ++ [
                (import ./configs/${args.hostname}/disko.nix args)
                ./configs/${args.hostname}/configuration.nix
              ];
            };
          }) my-systems
        );
      };
    };
}
