{
  description = "A secure-boot enable NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # wondring, but maybe just move flake out of etc/nixos and put directly in my dotfiles?

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    lanzaboote,
    nixvim,
    ...
  }: {
    nixosConfigurations.nixtop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        {_module.args = {inherit inputs;};}

        ./hosts/nixtop

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = inputs;

            users.johndr = import ./home/nixtop;
          };
        }

        lanzaboote.nixosModules.lanzaboote
        ({
          pkgs,
          lib,
          ...
        }: {
          environment.systemPackages = [
            pkgs.sbctl # debugging and troubleshooting secure boot
          ];

          # replace systemd-boot
          boot.loader.systemd-boot.enable = lib.mkForce false;
          boot.lanzaboote = {
            enable = true;
            pkiBundle = "/etc/secureboot";
          };
        })
      ];
    };

    nixosConfigurations.z420 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        {_module.args = {inherit inputs;};}

        ./hosts/z420

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = inputs;

            users.johndr = import ./home/z420;
          };
        }

        #        lanzaboote.nixosModules.lanzaboote ({ pkgs, lib, ...}: {
        #          environment.systemPackages = [
        #            pkgs.sbctl # debugging and troubleshooting secure boot
        #          ];
        #
        #          # replace systemd-boot
        #          boot.loader.systemd-boot.enable = lib.mkForce false;
        #          boot.lanzaboote = {
        #            enable = true;
        #            pkiBundle = "/etc/secureboot";
        #          };
        #        })
      ];
    };
  };
}
