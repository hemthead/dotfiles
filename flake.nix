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
  };

  # wondring, but maybe just move flake out of etc/nixos and put directly in my dotfiles?

  outputs = inputs@{ self, nixpkgs, home-manager, lanzaboote, ...}: {
    nixosConfigurations.nixtop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      modules = [
        {
      	  _module.args = { inherit inputs; };
	}

      	./hosts/nixtop

	home-manager.nixosModules.home-manager {
	  home-manager = {
	    useGlobalPkgs = true;
	    useUserPackages = true;

	    extraSpecialArgs = inputs;

  	    users.johndr = import ./home;
	  };
	}

	lanzaboote.nixosModules.lanzaboote ({ pkgs, lib, ...}: {
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
  };
}
