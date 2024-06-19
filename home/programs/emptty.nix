{ pkgs, config, ... }: {
  home.file.".config/emptty" = ''
    Name=Sway
    Exec=${pkgs.sway}/bin/sway
    Environment=wayland
  '';
}
