{ pkgs, config, ... }: {
  home.packages = with pkgs; [ mako ];
  services.mako = {
    # let colors = wayland.windowManager.sway.config.colors; in {
    enable = true;

    settings = {
    # FF's for alpha
      background-color = "${config.wayland.windowManager.sway.config.colors.focused.background}FF";
      border-color = "${config.wayland.windowManager.sway.config.colors.focused.border}FF";
      text-color = "${config.wayland.windowManager.sway.config.colors.focused.text}FF";
      progress-color = "over ${config.wayland.windowManager.sway.config.colors.focused.indicator}FF";
      layer = "overlay";
    };
  };
}
