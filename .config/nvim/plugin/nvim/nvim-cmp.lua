-- nvim-cmp
-- A completion plugin
vim.pack.add({
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-nvim-lua",
  "https://github.com/quangnguyen30192/cmp-nvim-ultisnips",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/micangl/cmp-vimtex",
  "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help",
  "https://github.com/hrsh7th/nvim-cmp",
})

local cmp = require("cmp")

cmp.setup({
  sources = cmp.config.sources({
    { name = "vimtex" },
    { name = "nvim_lsp" },
    { name = "ultisnips" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "nvim_lsp_signature_help" },
    -- { name = "buffer" },
  }),
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false`
    -- to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
  }),
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  view = {
    entries = "custom", -- can be "custom", "wildmenu" or "native"
  },
})
