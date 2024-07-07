{ pkgs
, nixvim
, ...
}: {
  imports = [ nixvim.homeManagerModules.nixvim ];

  # install LSPs on a per project basis with nix shell?
  home.packages = with pkgs; [ nil rust-analyzer clang ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    clipboard.providers.wl-copy.enable = true;

    opts = {
      number = true;
      relativenumber = true;

      completeopt = "menuone,preview,noinsert,noselect";

      signcolumn = "yes";

      scrolloff = 8;

      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
    };

    # colorscheme = "slate";
    colorschemes.everforest.enable = true;

    plugins.lightline = {
      enable = true;
      colorscheme = "powerline";
    };

    plugins.cmp.enable = true;
    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-vsnip.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp-cmdline.enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter
      fidget-nvim
      vim-vsnip
    ];

    extraConfigLua = builtins.readFile ./extraConfig.lua;
  };
}
