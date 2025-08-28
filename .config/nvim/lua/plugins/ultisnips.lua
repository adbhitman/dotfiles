return {
  -- ultisnips
  -- Allows to write own snippets to spesific languages or commonly all
  {
    "SirVer/ultisnips",
    init = function()
      -- Trigger configuration. You need to change this to something other
      -- than <tab> if you use one of the following:
      -- - https://github.com/Valloric/YouCompleteMe
      -- - https://github.com/nvim-lua/completion-nvim
      -- vim.g.UltiSnipsExpandTrigger="<tab>"
      -- vim.g.UltiSnipsJumpForwardTrigger="<c-b>"
      -- vim.g.UltiSnipsJumpBackwardTrigger="<c-z>"

      vim.g.UltiSnipsExpandTrigger = "<C-j>"
      vim.g.UltiSnipsJumpForwardTrigger = "<C-j>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<C-k>"

      -- If you want :UltiSnipsEdit to split your window.
      -- vim.g.UltiSnipsEditSplit = "vertical"
    end,
  },
}
