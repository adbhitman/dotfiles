return {
  -- gitsigns.nvim
  -- Git diff signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
}
