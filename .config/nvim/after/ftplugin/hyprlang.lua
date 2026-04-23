if vim.b.did_ftplugin_hyprlang then
  return
end

vim.b.did_ftplugin_hyprlang = 1

vim.opt_local.formatoptions:append("l")
