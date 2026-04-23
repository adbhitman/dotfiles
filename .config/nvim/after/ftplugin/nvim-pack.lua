if vim.b.did_ftplugin_lua then
  return
end

vim.b.did_ftplugin_lua = true

vim.keymap.set("n", "U", ":w<CR>", { buf = 0 })
vim.keymap.set("n", "q", ":tabclose<CR>", { silent = true, buf = 0 })
