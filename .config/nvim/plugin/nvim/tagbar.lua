-- tagbar
-- Dispalys tags
vim.pack.add({ "https://github.com/preservim/tagbar" })

vim.g.tagbar_width = 40
vim.keymap.set("n", "<Leader>tb", ":TagbarToggle<CR>", { noremap = true })
