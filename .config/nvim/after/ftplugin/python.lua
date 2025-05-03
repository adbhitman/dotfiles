if vim.b.did_ftplugin_python then
  return
end

vim.b.did_ftplugin_python = 1

vim.opt_local.textwidth = 88
vim.opt_local.formatoptions:append("l")
