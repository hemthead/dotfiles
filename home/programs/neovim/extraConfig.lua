-- LSPs
local lspconfig = require("lspconfig")

lspconfig.clangd.setup {
  filetypes = { "cpp", "objc", "objcpp", "cuda", "proto" },
} -- I give up with clangd for c
lspconfig.rust_analyzer.setup {}
lspconfig.nil_ls.setup {}
lspconfig.pyright.setup {}
lspconfig.lua_ls.setup {}
lspconfig.zls.setup {}

require("fidget").setup()

-- LSP lines pop up in window
-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false})
  end
})

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

-- Special thanks to @Jesse-Bakker for this fix (https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525)
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end

require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "~/obsidian-vault",
    },
  },

  completion = {
    nvim_cmp = true,
    min_chars = 2,
  },

  new_notes_location = "notes_subdir",

  -- determines how note IDs are generated given optional title
  ---@param title string|?
  ---@return string
  note_id_func = function(title)
    if title ~= nil then
      -- it title given, make it valid and return
      return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    end

    -- return time as title if none given
    return tostring(os.time())
  end,

  preferred_link_style = "wiki",

  -- optional
  templates = {
    folder = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
    -- key is variable and value function 
    --substitutions = {},
  },

  follow_url_func = function(url)
    -- open in default browser
    vim.fn.jobstart({"xdg-open", url})
  end,

  follow_img_func = function(img)
    vim.fn.jobstart({"xdg-open", img})
  end,

  picker = {
    name = "telescope.nvim",
  },

  sort_by = "modified",
  sort_reversed = true,

  search_max_lines = 1000,

  -- "current", "vsplit", or "hsplit"
  open_notes_in = "current",

  -- Optional, configure additional syntax highlighting / extmarks.
  -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
  ui = {
    enable = true,  -- set to false to disable all additional syntax features
    update_debounce = 200,  -- update delay after a text change (in milliseconds)
    max_file_length = 5000,  -- disable UI features for files with more than this many lines
    checkboxes = {
      -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
      [" "] = { hl_group = "ObsidianTodo" },
      ["x"] = { hl_group = "ObsidianDone" },
      [">"] = { hl_group = "ObsidianRightArrow" },
      ["~"] = { hl_group = "ObsidianTilde" },
      ["!"] = { hl_group = "ObsidianImportant" },
    },
    external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    reference_text = { hl_group = "ObsidianRefText" },
    highlight_text = { hl_group = "ObsidianHighlightText" },
    tags = { hl_group = "ObsidianTag" },
    block_ids = { hl_group = "ObsidianBlockID" },
    hl_groups = {
      -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
      ObsidianTodo = { bold = true, fg = "#f78c6c" },
      ObsidianDone = { bold = true, fg = "#89ddff" },
      ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
      ObsidianTilde = { bold = true, fg = "#ff5370" },
      ObsidianImportant = { bold = true, fg = "#d73128" },
      ObsidianBullet = { bold = true, fg = "#89ddff" },
      ObsidianRefText = { underline = true, fg = "#c792ea" },
      ObsidianExtLinkIcon = { fg = "#c792ea" },
      ObsidianTag = { italic = true, fg = "#89ddff" },
      ObsidianBlockID = { italic = true, fg = "#89ddff" },
      ObsidianHighlightText = { bg = "#75662e" },
    },
  },
})
