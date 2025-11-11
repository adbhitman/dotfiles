if vim.b.did_ftplugin_tex then
  return
end

vim.b.did_ftplugin_tex = 1

vim.opt_local.formatoptions:append("l")
