-- mason
vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

require("mason").setup({
  ui = {
    check_outdated_packages_on_open = false,
  },
})
