{ pkgs, ... }: {
  imports = [
    ../programs/vifm
    ../programs/git.nix
    ../programs/hyfetch.nix
    ../programs/direnv.nix
    ../programs/neovim
    ../programs/terminal-multiplexer.nix
  ];

  home = {
    username = "johndr";
    homeDirectory = "/home/johndr";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs;
    [
      # some of these may end up in the common config (likely)
    ];
}
