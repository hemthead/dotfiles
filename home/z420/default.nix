{ pkgs, ... }: {
  imports = [
    ../default.nix
  ];

  home.packages = with pkgs; [
    discord

    # some of these may end up in the common config (likely)
    gimp
    krita
    blender
    olive-editor
    godot_4
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [ obs-studio-plugins.wlrobs ];
  };
}
