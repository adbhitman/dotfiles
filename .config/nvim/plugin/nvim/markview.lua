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

  markdown = {
    list_items = {
      shift_width = function(buffer, item)
        ---@type integer Parent list items indent. Must be at least 1.
        local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)
        return item.indent * (1 / (parent_indnet * 2))
      end,
      marker_minus = {
        add_padding = function(_, item)
          return item.indent > 1
        end,
      },
    },
  },
})

vim.api.nvim_set_keymap(
  "n",
  "<leader>mv",
  "<CMD>Markview splitToggle<CR>",
  { desc = "Toggles `splitview` for current buffer." }
)
