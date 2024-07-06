{pkgs, ...}: {
  home.packages = with pkgs; [swaylock];

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      image = "${../../wallpaper}";
    };
  };
}
