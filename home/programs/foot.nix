{ pkgs, ... }: {
  programs.foot = {
    enable = true;

    settings.colors.alpha = 0.75;
    settings.main.font = "monospace:size=10";
  };
}
