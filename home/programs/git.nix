{ pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "John Reed";
    userEmail = "ReallyJohnReed+git@gmail.com";
  };
}
