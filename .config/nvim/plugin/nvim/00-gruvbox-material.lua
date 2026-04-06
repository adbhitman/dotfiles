-- gruvbox-material
-- Color themes
vim.pack.add({ "https://github.com/sainnhe/gruvbox-material" })

if vim.fn.has("termguicolors") == 1 then
  vim.o.termguicolors = true
end

vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_foreground = "mix"
vim.o.background = "dark"

vim.cmd.colorscheme("gruvbox-material")
