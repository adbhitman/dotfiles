return {
  -- nvim-cmp
  -- A completion plugin
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "hrsh7th/cmp-path",
      "micangl/cmp-vimtex",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
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
          -- If you want insert `(` after select function or method item
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done()),
        }),
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = "custom", -- can be "custom", "wildmenu" or "native"
        },
      })
    end,
  },
}
