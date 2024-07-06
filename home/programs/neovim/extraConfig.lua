-- LSPs
local lspconfig = require("lspconfig")

lspconfig.clangd.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.nil_ls.setup {}

require("fidget").setup()

-- Setup Completion
local cmp = require("cmp")
cmp.setup({
  preselect = cmp.PreselectMode.None,

  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),

    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),

    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
  }, {
    { name = "buffer" },
    { name = "path"  },
  })
})

-- Use buffer source for `/` and `?` (no work with `native_menu`)
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for `:` (no work with `native_menu`)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
  matching = { disallow_symbol_nonprefix_matching = false },
})
