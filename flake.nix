{
  description = "A secure-boot enabled NixOS configuration flake";

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

  outputs =
    inputs @ { self
    , nixpkgs
    , home-manager
    , lanzaboote
    , nixvim
    , ...
    }: {

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations.nixtop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          { _module.args = { inherit inputs; }; }

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
          ({ pkgs
           , lib
           , ...
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
          { _module.args = { inherit inputs; }; }

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

      nixosConfigurations.home-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          { _module.args = { inherit inputs; }; }

          ./hosts/home-server

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = inputs;

              users.johndr = import ./home/home-server;
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
