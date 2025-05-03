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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?ref=refs%2Fheads%2Fmain&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprcursor.follows = "hyprcursor";
    };
    hyprland-plugins = {
      url = "git+https://github.com/hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

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
            modules = [
              inputs.disko.nixosModules.default
              (import ./disko.nix { inherit device; })

              ./configs/nixos/configuration.nix

              inputs.home-manager.nixosModules.default
              inputs.impermanence.nixosModules.impermanence
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
        };
      };
    };
}
