-- nvim-autopairs
-- adds brackets etc. automatically
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })
  end,
})
