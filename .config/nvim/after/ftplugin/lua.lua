if vim.b.did_ftplugin_lua then
  return
end

vim.b.did_ftplugin_lua = true

vim.opt_local.foldlevel = 1
vim.opt_local.foldmethod = "marker"
vim.opt_local.formatoptions:append("l")
