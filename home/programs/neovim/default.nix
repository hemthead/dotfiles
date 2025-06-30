{ pkgs
, ...
}: {
  xdg.configFile."nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/hemthead/kickstart.nvim";
      rev = "29039cf703a5bdb890942dd006f35e925c226c66";
    };
    recursive = true;
  };

  home.shellAliases = {
    "kickstart-nvim" = "NVIM_APPNAME='kickstart-nvim' nvim";
  };
}
