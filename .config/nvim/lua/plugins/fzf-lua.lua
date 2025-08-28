return {
  -- fzf-lua
  {
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("fzf-lua").setup({
          "fzf-native",
          -- "default",
          winopts = {
            preview = {
              default = "bat",
              layout = "flex", -- horizontal|vertical|flex
              hidden = false,
            },
          },
          fzf_opts = {
            -- ["--layout"] = "reverse-list",
            -- nullify fzf-lua's settings to inherit from FZF_DEFAULT_OPTS
            ["--info"] = false,
            ["--layout"] = false,
          },
        })

        vim.keymap.set("n", "<Leader>b", ":FzfLua buffers<CR>", { noremap = true })
        vim.keymap.set("n", "<Leader>c", ":FzfLua commands<CR>", { noremap = true })
        vim.keymap.set("n", "<Leader>s", ":FzfLua files<CR>", { noremap = true })
        vim.keymap.set("n", "q:", ":FzfLua command_history<CR>", { noremap = true })
        vim.keymap.set("n", "Q:", ":FzfLua<CR>", { noremap = true })
      end,
    },
  },
}
