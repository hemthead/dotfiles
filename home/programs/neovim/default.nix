{ pkgs
, nixvim
, ...
}: {
  imports = [ nixvim.homeManagerModules.nixvim ];

  # install LSPs on a per project basis with nix shell?
  home.packages = with pkgs; [ nil ];

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

      # default indent of 4
      shiftwidth = 4;
      tabstop = 4;

      wrap = false;
    };

    keymaps = [
      {
        # open a terminal panel and resize it
        action.__raw = ''
          function()
            vim.api.nvim_open_win(0, true, {
              split = 'below',
              height = 10,
              win = 0
            })
            vim.cmd("terminal")
            vim.cmd("set winfixheight")
          end
        '';
        key = "<C-`>";
        mode = [ "n" ];
      }
      {
        # toggle folds with space
        action = "za";
        key = "<Space>";
        mode = [ "n" "v" ];
      }
    ];

    autoCmd = [
      {
        desc = "Open all folds on buffer create";
        command = "normal zR";
        event = [
          "BufEnter"
          "BufWinEnter"
        ];
      }
    ];

    # colorscheme = "slate";
    colorschemes.everforest.enable = true;
    # maybe do some alpha-seethrough stuff here?

    plugins.lightline = {
      enable = true;
      settings.colorscheme = "everforest";
    };

    plugins.cmp.enable = true;
    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-vsnip.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp-cmdline.enable = true;

    plugins.treesitter = {
      enable = true;
      folding = true;
      settings = {
        highlight.enable = true;
        incremental_selection.enable = true;
        indent.enable = true;
      };

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        cpp
        css
        disassembly
        #gdscript
        html
        javascript
        lua
        make
        markdown
        nix
        regex
        rust
        #sql
        #toml
        #vim
        #vimdoc
      ];
    };

    plugins.nvim-tree = {
      enable = true;
      openOnSetup = true;
      openOnSetupFile = true;
      extraOptions = {
        filters.git_ignored = false;
      };
    };
    plugins.web-devicons.enable = true; # enable for nvim-tree

    # It's about time I experiment with this
    plugins.telescope.enable = true;


    extraPlugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      fidget-nvim
      vim-vsnip
      vim-gutentags
      pkgs.universal-ctags
      # getting on that obsidian grind rn
      obsidian-nvim
    ];

    extraConfigLua = builtins.readFile ./extraConfig.lua;
    extraConfigLuaPost = builtins.readFile ./extraConfigPost.lua;

    extraFiles = {
      "ftplugin/nix.lua".source = ./two-indent.lua;
      "ftplugin/html.lua".source = ./two-indent.lua;
      "ftplugin/lua.lua".source = ./two-indent.lua;
    };
  };
}
