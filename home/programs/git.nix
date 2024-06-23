{ pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "John Reed";
    userEmail = "ReallyJohnReed+git@gmail.com";

    signing.key = "/home/johndr/.ssh/id_ed25519.pub";
    signing.signByDefault = true;

    extraConfig = {
      gpg.format = "ssh";
    };
  };
}
