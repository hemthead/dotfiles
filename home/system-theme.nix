{ pkgs, ... }: {
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  wayland.windowManager.sway.wrapperFeatures.gtk = true;

  gtk = {
    enable = true;

    theme.name = "Adwaita-dark";
    theme.package = pkgs.gnome-themes-extra;
    iconTheme.name = "Adwaita";
    iconTheme.package = pkgs.adwaita-icon-theme;
    
    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = "true"
    '';

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
