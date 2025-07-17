{
  imports = [ ../default.nix ./swayidle.nix ];
  wayland.windowManager.sway.extraConfig =
    ''input * xkb_options "caps:swapescape"'';
}
