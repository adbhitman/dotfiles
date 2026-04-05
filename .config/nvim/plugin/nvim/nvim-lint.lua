-- nvim-lint
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

require("lint").linters_by_ft = {
  lua = { "luac" },
  markdown = { "rumdl" },
  python = { "ruff" },
  sh = { "shellcheck" },
}

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave", "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local diag = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
    if #diag > 0 then
      vim.api.nvim_echo({ { diag[1].message } }, false, {})
    end
  end,
})
