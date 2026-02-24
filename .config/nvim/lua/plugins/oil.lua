return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  ---@type oil.SetupOpts
  config = function()
    require("oil").setup({
      view_options = {
        show_hidden = true,
      },
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      delete_to_trash = true,
      float = {
        max_width = 0.5,
        max_height = 0.7,
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "auto",
      },
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,
    })

    vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
  end,
}

-- `       :cd to the current oil directory
-- g~      :cd to the current oil directory { scope = "tab" }
-- gs      Change the sort order
-- <C-c>   Close oil and restore original buffer
-- g\      Jump to and from the trash for the current directory"
-- -       Navigate to the parent path
-- _       Open oil in Neovim's current working directory
-- <CR>    Open the entry under the cursor
-- <C-p>   Open the entry under the cursor in a preview window, or close the preview window if already open
-- gx      Open the entry under the cursor in an external program
-- <C-h>   Open the entry under the cursor { horizontal = true }
-- <C-t>   Open the entry under the cursor { tab = true }
-- <C-s>   Open the entry under the cursor { vertical = true }
-- <C-l>   Refresh current directory list
-- g?      Show default keymaps
-- g.      Toggle hidden files and directories
