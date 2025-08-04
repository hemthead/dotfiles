{ pkgs, ... }: rec {
  imports = [ ../default.nix ./swayidle.nix ];

  home.packages = with pkgs; [
    discord
    signal-desktop
    # matrix client when I get that working (run my own server)

    # some of these may end up in the common config (likely)
    gimp
    krita # tried mypaint but I don't want to fix it not working
    blender
    shotcut
    godot_4
    prismlauncher # minecraft

    lutris-free # gaming

    strawberry # music!
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

  wayland.windowManager.sway.extraConfig = ''
    output DP-1 pos 0 0
    exec swaymsg focus output DP-1

    #output HDMI-A-1 transform 270
    output HDMI-A-1 pos 1920 0

    workspace 1 output DP-1
    workspace 10 output HDMI-A-1
  '';
}
