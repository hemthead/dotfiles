{ pkgs, ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  home.file.".bashrc".text = ''
    eval "$(direnv hook bash)"
  '';
}
