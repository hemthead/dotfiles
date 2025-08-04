{
  description = "A secure-boot enabled NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, zen-browser, ... }: {

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

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
      ];
    };

    nixosConfigurations.opti = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        { _module.args = { inherit inputs; }; }

        ./hosts/opti

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = inputs;

            users.johndr = import ./home/opti;
          };
        }
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
      ];
    };
  };
}
