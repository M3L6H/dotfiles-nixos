{
  description = "Home of Artemis";

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
      url = "/home/sanshiliu/files/dev/m3l6h/dotfiles-ai";
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
      device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_4TB_S757NS0X302547W";
      hostname = "nixos";
      system = "x86_64-linux";
      username = "m3l6h";

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
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ system ];

      flake = {
        # NixOS configuration entrypoint
        # Available through 'sudo nixos-rebuild switch --flake .#hostname'
        nixosConfigurations = {
          "${hostname}" = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit
                device
                hostname
                inputs
                username
                ;
            };
            modules = modules ++ [
              (import ./disko.nix { inherit device; })
              ./configs/nixos/configuration.nix
            ];
          };
          laptop = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit
                inputs
                ;
              device = "/dev/disk/by-id/wwn-0x5002538700000000";
              hostname = "laptop";
              username = "sanshiliu";
            };
            modules = modules ++ [
              (import ./laptop-disko.nix { })
              ./configs/laptop/configuration.nix
            ];
          };
        };

        # Standalone home-manager configuration entrypoint
        # Available through 'home-manager switch --flake .#username'
        homeConfigurations = {
          "${username}" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit hostname inputs username;
            };
            modules = [
              ./homes/${username}/home.nix
            ];
          };
          sanshiliu = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs;
              hostname = "laptop";
              username = "sanshiliu";
            };
            modules = [
              ./homes/sanshiliu/home.nix
            ];
          };
        };
      };
    };
}
