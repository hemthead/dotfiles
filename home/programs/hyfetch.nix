{ pkgs, ... }: {
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;
      color_align = {
        mode = "custom";
        custom_colors = {
          "2" = 0;
          "1" = 1;
        };
        fore_back = [ ];
      };
      backend = "neofetch";
      args = null;
      distro = null;
      pride_month_shown = [ ];
      pride_month_disable = false;
    };
  };
}
