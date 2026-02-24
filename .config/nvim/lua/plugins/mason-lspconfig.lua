return {
  -- mason-lspconfig.nvim
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        -- ensure_installed = { "lua_ls", "rust_analyzer" },
        -- automatic_installation = true,
      })
    end,
  },
}
