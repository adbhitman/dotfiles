if vim.b.did_ftplugin_tex then
  return
end

vim.b.did_ftplugin_tex = 1

-- Change vimtex autocomplete to run only once mode
vim.keymap.set("n", "<localleader>ss", "<plug>(vimtex-compile-ss)", { buffer = true, noremap = true })

vim.opt_local.formatoptions:append("l")
