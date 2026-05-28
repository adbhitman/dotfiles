-- ultisnips
-- Allows to write own snippets to spesific languages or commonly all

-- Define your global ultisnips shortcuts before loading to pluging to actually
-- get those to work
vim.g.UltiSnipsExpandOrJumpTrigger = "<c-j>"

-- If you want :UltiSnipsEdit to split your window.
-- vim.g.UltiSnipsEditSplit = "vertical"

-- Load the plugin
vim.pack.add({ "https://github.com/SirVer/ultisnips" })
