{ config, pkgs, ... }: {
  imports = [ ./config ./sway ./programs ./system-theme.nix ];

  home = {
    username = "johndr";
    homeDirectory = "/home/johndr";

    stateVersion = "24.11";

    sessionVariables = { NIX_SHELL_PRESERVER_PROMPT = 1; };
  };

  programs.home-manager.enable = true;
}
