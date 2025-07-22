{ pkgs, ... }: {
  home.packages = with pkgs; [
    ripgrep # awesomesauce?
    fd
  ];

  programs.foot = {
    enable = false;

    settings.colors.alpha = 0.75;
    settings.main.font = "monospace:size=10";
  };

  programs.ghostty.enable = true;
  xdg.configFile."ghostty/config".text = builtins.readFile ./ghostty.config;

  programs.tmux = {
    enable = true;

    keyMode = "vi";
    mouse = false;
    terminal = "tmux-256color";
    extraConfig = ''
      set -sg escape-time 0
    '';
  };

  # trying this out
  programs.bat.enable = true;

  programs.git = {
    enable = true;

    userName = "John Reed";
    extraConfig.author.name = "John Reed";
    userEmail = "reallyjohnreed@gmail.com";

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

  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;
      color_align = {
        mode = "custom";
        custom_colors = {
          "2" = 0;
          "1" = 1;
        };
        fore_back = [ ];
      };
      backend = "neofetch";
      args = null;
      distro = null;
      pride_month_shown = [ ];
      pride_month_disable = false;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./bashrc;
  };
  home.file.".bashrc".text = ''
    eval "$(direnv hook bash)"
  '';
}
