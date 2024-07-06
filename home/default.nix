{
  config,
  pkgs,
  ...
}: {
  imports = [./sway ./programs];

  home = {
    username = "johndr";
    homeDirectory = "/home/johndr";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
