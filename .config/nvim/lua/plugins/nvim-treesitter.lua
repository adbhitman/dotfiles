return {
  -- nvim-treesitter
  -- advanced higlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    branch = "main",
    config = function()
      require("nvim-treesitter").setup({
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = false },
      })
    end,
  },
}
