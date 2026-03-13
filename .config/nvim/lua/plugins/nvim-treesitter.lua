return {
  -- nvim-treesitter
  -- advanced higlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup({})

      -- From treesitter manual
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash",
          "css",
          "html",
          "hurl",
          "java",
          "javadoc",
          "jinja",
          "jinja_inline",
          "json",
          "json5",
          "lua",
          "markdown",
          "python",
          "regex",
          "sql",
        },

        callback = function()
          -- syntax highlighting, provided by Neovim
          vim.treesitter.start()
          -- folds, provided by Neovim
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          -- indentation, provided by nvim-treesitter
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
