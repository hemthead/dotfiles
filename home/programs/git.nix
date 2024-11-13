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

    # setup for git send-email
    extraConfig.sendemail = {
      smtpServer = "smtp.gmail.com";
      smtpUser = "reallyjohnreed@gmail.com";
      smtpEncryption = "tls";
      smtpServerPort = 587;
    };
    # store smtpPass in special file, since I can't put it here
    extraConfig.credential.helper = "store";
  };
}
