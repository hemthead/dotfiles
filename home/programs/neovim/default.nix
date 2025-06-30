{ pkgs, ... }: {
  xdg.configFile."nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/hemthead/kickstart.nvim";
      rev = "ef098b82867e650bb2cb3e78216dff41b9a45957";
    };
    recursive = true;
  };

  home.shellAliases = {
    "kickstart-nvim" = "NVIM_APPNAME='kickstart-nvim' nvim";
  };
}
