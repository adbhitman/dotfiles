-- mason-lspconfig.nvim
vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

require("mason-lspconfig").setup({
  -- ensure_installed = { "lua_ls", "rust_analyzer" },
  -- automatic_installation = true,
})
