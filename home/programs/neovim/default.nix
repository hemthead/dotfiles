{ pkgs, ... }: {
  xdg.configFile."nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/hemthead/kickstart.nvim";
      rev = "fae6a3609cb3bb4b6f9a0314098e5e16487702f3";
    };
    recursive = true;
  };

  home.shellAliases = {
    "kickstart-nvim" = "NVIM_APPNAME='kickstart-nvim' nvim";
  };
}
