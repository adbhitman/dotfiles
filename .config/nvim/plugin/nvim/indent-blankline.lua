-- indent-blankline.nvim
-- make indentation lines
vim.pack.add({ { src = "https://github.com/lukas-reineke/indent-blankline.nvim", name = "ibl" } })

require("ibl").setup({
  indent = {
    char = "▏",
  },
  scope = {
    enabled = true,
  },
})
