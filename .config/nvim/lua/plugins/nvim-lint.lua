return {
  -- nvim-lint
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        lua = { "luac" },
        markdown = { "markdownlint" },
        python = { "ruff" },
        sh = { "shellcheck" },
      }

      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = false,
        -- virtual_text = { current_line = false },
        -- virtual_lines = { current_line = true },
        -- float = {
        --   focusable = true, -- Whether the float window should be focusable
        --   style = "minimal", -- Optionally set the float style (can be 'minimal' or 'normal')
        --   -- border = "rounded", -- Optionally set a border style for the float
        -- },
      })

      vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave", "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
