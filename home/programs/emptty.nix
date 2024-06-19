{ pkgs, config, ... }: {
  home.file.".config/emptty".text = ''
    Name=Sway
    Exec=${pkgs.sway}/bin/sway
    Environment=wayland
  '';
}
