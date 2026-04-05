-- markview.nvim
-- Renders markdown pretty way
vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/OXY2DEV/markview.nvim",
})

require("markview").setup({
  preview = {
    enable = false,
    icon_provider = "devicons", -- "mini" or "devicons"
  },
})

vim.api.nvim_set_keymap(
  "n",
  "<leader>mv",
  "<CMD>Markview splitToggle<CR>",
  { desc = "Toggles `splitview` for current buffer." }
)
