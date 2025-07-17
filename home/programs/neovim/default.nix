{ pkgs, ... }: {
  xdg.configFile."nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/hemthead/kickstart.nvim";
      rev = "e524918a70b2dc5a0f0b67b21c678d3696d38123";
    };
    recursive = true;
  };

  home.shellAliases = {
    "kickstart-nvim" = "NVIM_APPNAME='kickstart-nvim' nvim";
  };
}
