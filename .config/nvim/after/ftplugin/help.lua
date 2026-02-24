if vim.b.did_ftplugin_lua then
  return
end

vim.b.did_ftplugin_lua = true

vim.fn.execute("wincmd L")
