{ pkgs, ... }: {
  imports = [
    ../default.nix
  ];

  home.packages = with pkgs; [
    discord

    # some of these may end up in the common config (likely)
    gimp
    krita # tried mypaint but I don't want to fix it not working
    blender
    olive-editor
    godot_4
    prismlauncher
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [ obs-studio-plugins.wlrobs ];
  };

  # virtualization and qemu
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
