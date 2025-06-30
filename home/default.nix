{ config, pkgs, ... }: {
  imports = [ ./config ./sway ./programs ./system-theme.nix ];

  home = {
    username = "johndr";
    homeDirectory = "/home/johndr";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
