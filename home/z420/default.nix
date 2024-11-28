{ pkgs, ... }: {
  imports = [
    ../default.nix
    ./swayidle.nix
  ];

  home.packages = with pkgs; [
    discord

    # some of these may end up in the common config (likely)
    gimp
    krita # tried mypaint but I don't want to fix it not working
    blender
    olive-editor
    godot_4
    prismlauncher # minecraft, use steam-run

    lutris-free # gaming
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [ 
      obs-studio-plugins.wlrobs 
      obs-studio-plugins.obs-pipewire-audio-capture
    ];
  };

  # virtualization and qemu
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
