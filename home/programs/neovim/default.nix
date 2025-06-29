{ pkgs
, ...
}: {
  xdg.configFile."nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/hemthead/kickstart.nvim";
      rev = "fce36d59e4704fe7536a692a1d725801fdcf75a4";
    };
    recursive = true;
  };
}
