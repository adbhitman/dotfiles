return {
  -- nvim-dap
  -- debugger
  {
    "mfussenegger/nvim-dap",
  },
  -- }}}
  -- nvim-dap-ui {{{
  -- UI for nvim-dap
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },
}
