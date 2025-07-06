{ pkgs, ... }: {
  xdg.configFile."nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/hemthead/kickstart.nvim";
      rev = "b03bebc86770b81e00171fea899d56f986ca1fb1";
    };
    recursive = true;
  };

  home.shellAliases = {
    "kickstart-nvim" = "NVIM_APPNAME='kickstart-nvim' nvim";
  };
}
