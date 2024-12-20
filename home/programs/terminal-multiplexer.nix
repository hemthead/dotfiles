{ pkgs, ... }: {
  programs.tmux = {
    enable = true;

    keyMode = "vi";
    mouse = false;
    terminal = "tmux-256color";
    extraConfig = ''
      set -sg escape-time 0
    '';
  };
}

