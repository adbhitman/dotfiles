if vim.b.did_ftplugin_markdown then
  return
end

vim.b.did_ftplugin_markdown = true

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.textwidth = 80

vim.b.ale_fix_on_save = 1

require("conform").setup({
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})
