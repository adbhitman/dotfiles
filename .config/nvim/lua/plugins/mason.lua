return {
  -- mason
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          check_outdated_packages_on_open = false,
        },
      })
    end,
  },
}
