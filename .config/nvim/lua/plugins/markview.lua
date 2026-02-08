return {
  -- markview.nvim
  -- Renders markdown pretty way
  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },

    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
      require("markview").setup({
        preview = {
          enable = false,
          icon_provider = "devicons", -- "mini" or "devicons"
        },
      })

      vim.api.nvim_set_keymap(
        "n",
        "<leader>md",
        "<CMD>Markview splitToggle<CR>",
        { desc = "Toggles `splitview` for current buffer." }
      )
    end,
  },
}
