-- nvim-treesitter
-- advanced higlighting

-- create a hook to run :TSUpdate after if treesitter is updated
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
})

require("nvim-treesitter").setup({})

-- Commented out are reminders what are installed default in neovim
local pattern = {
  "bash",
  -- "c",
  "css",
  -- "diff"
  "html",
  "hurl",
  "java",
  "javadoc",
  "jinja",
  "jinja_inline",
  "json",
  "json5",
  -- "lua",
  -- "markdown",
  -- "markdown_inline"
  "python",
  -- "query",
  "regex",
  "sql",
  -- "vim",
  -- "vimdoc",
}

require("nvim-treesitter").install(pattern)

-- From treesitter manual
vim.api.nvim_create_autocmd("FileType", {
  pattern = pattern,

  callback = function()
    -- syntax highlighting, provided by Neovim
    vim.treesitter.start()
    -- folds, provided by Neovim
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"
    -- indentation, provided by nvim-treesitter
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
