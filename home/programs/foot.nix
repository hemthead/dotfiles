{ pkgs, ... }: {
  programs.foot = {
    enable = true;

    settings.colors.alpha = 0.75;
  };
}
