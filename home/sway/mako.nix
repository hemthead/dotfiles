{ pkgs, config, ... }: {
  home.packages = with pkgs; [ mako ];
  services.mako = {
    # let colors = wayland.windowManager.sway.config.colors; in {
    enable = true;
    # FF's for alpha
    backgroundColor = "${config.wayland.windowManager.sway.config.colors.focused.background}FF";
    borderColor = "${config.wayland.windowManager.sway.config.colors.focused.border}FF";
    textColor = "${config.wayland.windowManager.sway.config.colors.focused.text}FF";
    progressColor = "over ${config.wayland.windowManager.sway.config.colors.focused.indicator}FF";
    layer = "overlay";
  };
}
