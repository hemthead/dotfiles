{ pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "John Reed";
    extraConfig.author.name = "John Reed";
    userEmail = "reallyjohnreed+git@gmail.com";

    signing.key = "/home/johndr/.ssh/id_ed25519.pub";
    signing.signByDefault = true;
    extraConfig.gpg.format = "ssh";

    extraConfig.init.defaultBranch = "main";

    extraConfig.url."https://github.com/".insteadOf = [ "gh:" "github:" ];
  };
}
