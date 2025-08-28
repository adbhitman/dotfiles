return {
  -- tagbar
  -- Dispalys tags
  {
    "preservim/tagbar",
    init = function()
      vim.g.tagbar_width = 40
      vim.keymap.set("n", "<Leader>tb", ":TagbarToggle<CR>", { noremap = true })
    end,
  },
}
