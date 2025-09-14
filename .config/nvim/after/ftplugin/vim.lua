if vim.b.did_ftplugin_vim then
  return
end

vim.b.did_ftplugin_vim = 1

vim.opt_local.formatoptions:append("l")
