return {
  -- fzf-lua
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {},
    ---@diagnostic enable: missing-fields
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
          ["--cycle"] = true,
        },
        -- complete_path = {
        --   cmd = "fd --type d --hidden", -- default: auto detect fd|rg|find
        -- },
      })

      vim.keymap.set("n", "<Leader>b", ":FzfLua buffers<CR>")
      vim.keymap.set("n", "<Leader>c", ":FzfLua commands<CR>")
      vim.keymap.set("n", "<Leader>C", ":FzfLua builtin<CR>")
      vim.keymap.set("n", "<Leader>s", ":FzfLua files<CR>")
      vim.keymap.set("n", "q:", ":FzfLua command_history<CR>")
      vim.keymap.set("n", "<Leader>r", ":FzfLua resume<CR>")
      vim.keymap.set("n", "<Leader>dd", ":FzfLua diagnostics_document<CR>")
      vim.keymap.set("n", "<Leader>dw", ":FzfLua diagnostics_workspace<CR>")
      vim.keymap.set("n", "<Leader>dld", ":FzfLua lsp_document_diagnostics<CR>")
      vim.keymap.set("n", "<Leader>dlw", ":FzfLua lsp_workspace_diagnostics<CR>")

      function Fzf_cd(cmd_command)
        cmd_command = cmd_command or ""
        require("fzf-lua").fzf_exec(cmd_command, {
          prompt = "cd> ",
          actions = {
            ["default"] = function(selected)
              vim.cmd.lcd(selected[1])
            end,
          },
        })
      end

      vim.keymap.set("n", "<Leader>pp", function()
        Fzf_cd("fd --type d --type l --hidden . $HOME")
      end)
      vim.keymap.set("n", "<Leader>pl", function()
        Fzf_cd("fd --type d --hidden .")
      end)
      vim.keymap.set("n", "<Leader>pg", function()
        Fzf_cd("fd --type d --hidden . /")
      end)
    end,
  },
}
