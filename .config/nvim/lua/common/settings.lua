vim.o.compatible = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.encoding = "utf-8"
--vim.o.fileformat=unix
--vim.o.fileencoding=utf-8

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.autoread = true
vim.o.splitright = true

vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- sets tabs to spaces
vim.o.tabstop = 4 -- Size of TAB as spaces=true
vim.o.softtabstop = 4 -- Sets the number of columns for a TAB=true
vim.o.shiftwidth = 4 -- Indents will have a width of 4=true
vim.o.expandtab = true -- Expand TABs to spaces=true
vim.o.autoindent = true -- Copy indent from current line when starting a new line.=true
vim.o.smartindent = true

vim.opt.backspace = { "indent", "eol", "start" }
vim.o.joinspaces = false

vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.completeopt = { "menuone", "preview", "popup", "fuzzy", "noselect" }

vim.o.history = 1000
vim.opt.messagesopt = { "hit-enter", "history:1000" }
--vim.o.autochdir=true

vim.o.wildmenu = true
vim.opt.wildmode = { "longest", "list" }
vim.opt.wildignore = {
  "*.docx",
  "*.exe",
  "*.flv",
  "*.gif",
  "*.img",
  "*.jpg",
  "*.pdf",
  "*.png",
  "*.pyc",
  "*.xlsx",
}

vim.o.hidden = true
vim.o.showcmd = true
--vim.o.title=true
vim.o.laststatus = 2

vim.o.timeout = true
vim.o.ttimeoutlen = 100
--vim.o.ruler=true
vim.o.scrolloff = 5

vim.o.cursorline = true
--vim.o.cursorcolumn=true

vim.api.nvim_create_augroup("setcolorcolumn", {})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = "setcolorcolumn",
  callback = function()
    if vim.bo.textwidth == 0 then
      vim.bo.textwidth = 80
    end

    vim.wo.colorcolumn = "+1"
  end,
})

vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 0, guibg = lightgrey })

vim.o.spell = false
--vim.o.spelllang='en'
