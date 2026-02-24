return {
  -- nvim-lint
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        lua = { "luac" },
        markdown = { "rumdl" },
        python = { "ruff" },
        sh = { "shellcheck" },
      }

      vim.diagnostic.config({
        -- virtual_text = { current_line = true },
        -- virtual_lines = { current_line = true },
      })

      vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave", "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
