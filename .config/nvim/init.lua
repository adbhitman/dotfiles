-- COMMON {{{
-- Common settings {{{
vim.o.compatible = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.encoding = "utf-8"
--vim.o.fileformat=unix
--vim.o.fileencoding=utf-8

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.autoread = true
vim.o.splitright = true

-- sets tabs to spaces
vim.o.tabstop = 4 -- Size of TAB as spaces=true
vim.o.softtabstop = 4 -- Sets the number of columns for a TAB=true
vim.o.shiftwidth = 4 -- Indents will have a width of 4=true
vim.o.expandtab = true -- Expand TABs to spaces=true
vim.o.autoindent = true -- Copy indent from current line when starting a new line.=true
vim.o.smartindent = true

vim.opt.backspace = { "indent", "eol", "start" }
vim.o.joinspaces = false

vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.completeopt = { "menuone", "preview", "popup", "fuzzy", "noselect" }

vim.o.history = 1000
vim.opt.messagesopt = { "hit-enter", "history:1000" }
--vim.o.autochdir=true

vim.o.wildmenu = true
vim.opt.wildmode = { "longest", "list" }
vim.opt.wildignore = {
  "*.docx",
  "*.exe",
  "*.flv",
  "*.gif",
  "*.img",
  "*.jpg",
  "*.pdf",
  "*.png",
  "*.pyc",
  "*.xlsx",
}

vim.o.hidden = true
vim.o.showcmd = true
--vim.o.title=true
vim.o.laststatus = 2

vim.o.timeout = true
vim.o.ttimeoutlen = 100
--vim.o.ruler=true
vim.o.scrolloff = 5

vim.o.cursorline = true
--vim.o.cursorcolumn=true

vim.api.nvim_create_augroup("setcolorcolumn", {})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = "setcolorcolumn",
  callback = function()
    if vim.bo.textwidth == 0 then
      vim.bo.textwidth = 80
    end

    vim.wo.colorcolumn = "+1"
  end,
})

vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 0, guibg = lightgrey })

vim.o.spell = false
--vim.o.spelllang='en'
-- }}}
-- Mappings {{{
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true })
vim.keymap.set("n", "Q", "<Nop>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true })

vim.opt_local.mouse = "a"

function ToggleMouse()
  local mouse_value = vim.opt_local.mouse:get()

  local is_mouse_enabled = mouse_value["a"] == true

  if is_mouse_enabled then
    vim.opt_local.mouse = ""
  else
    vim.opt_local.mouse = "a"
  end

  print("New mouse value:", vim.inspect(vim.opt_local.mouse:get()))
end

function ShowCodeOutput(compiler)
  local pattern = "__" .. vim.fn.bufname("%") .. "_output__"
  local windowNr = vim.fn.bufwinnr(pattern)

  local code = vim.fn.system(compiler .. " " .. vim.fn.bufname("%") .. " 2>&1")

  if windowNr > 0 then
    vim.cmd("execute" .. windowNr .. " 'wincmd w'")
  else
    vim.cmd("execute 'vsplit " .. pattern .. "'")
  end

  vim.cmd("normal! ggdG")
  vim.opt_local.buftype = "nofile"

  vim.fn.append(0, vim.fn.split(code, "\n"))
  vim.cmd("execute 'wincmd p'")
end

vim.keymap.set("n", "<Leader>tm", ToggleMouse, { noremap = true })
vim.keymap.set({ "n" }, "<F8>", ":w | lua ShowCodeOutput('python3')<CR>", { noremap = true })
vim.keymap.set({ "i" }, "<F8>", "<Esc>:w | lua ShowCodeOutput('python3')<CR>", { noremap = true })
-- }}}
-- }}}

-- PLUGINS {{{
-- Bootstrap lazy.nvim {{{
-- folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- }}}
-- lazy.nvim {{{
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- conform.nvim {{{
    -- code formatter
    {
      "stevearc/conform.nvim",
      event = {},
      cmd = { "ConformInfo" },
      keys = {
        {
          -- Customize or remove this keymap to your liking
          "<Leader>f",
          function()
            require("conform").format({ async = true })
          end,
          mode = "",
          desc = "Format buffer",
        },
      },
      -- This will provide type hinting with LuaLS
      ---@module "conform"
      ---@type conform.setupOpts
      opts = {
        -- Define your formatters
        formatters_by_ft = {
          lua = { "stylua" },
          css = { "prettier" },
          html = { "prettier" },
          javascript = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          markdown = { "prettier" },
          python = { "ruff" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          tex = { "latexindent" },

          -- Use the "*" filetype to run formatters on all filetypes.
          -- ["*"] = { "codespell" },
          -- Use the "_" filetype to run formatters on filetypes that don't
          -- have other formatters configured.
          ["_"] = { "trim_whitespace" },
          -- You can now set a custom `lsp_format` option inside the "_" wildcard
          -- itself. For example:
          -- ["_"] = { "trim_whitespace", lsp_format = "last" },
        },
        -- Set default options
        default_format_opts = {
          lsp_format = "fallback",
        },
        -- Set up format-on-save
        -- format_on_save = { timeout_ms = 500 },
        -- Customize formatters
        --   formatters = {
        --     shfmt = {
        --       prepend_args = { "-i", "2" },
        --     },
        --   },
      },
      -- init = function()
      --   -- If you want the formatexpr, here is the place to set it
      --   vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      -- end,
    },
    -- }}}
    -- fzf-lua {{{
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
    -- }}}
    -- gitsigns.nvim {{{
    -- Git diff signs
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end,
    },
    -- }}}
    -- gruvbox-material {{{
    -- Color themes
    {
      "sainnhe/gruvbox-material",
      lazy = false,
      priority = 1000,
      config = function()
        if vim.fn.has("termguicolors") == 1 then
          vim.o.termguicolors = true
        end

        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_foreground = "mix"
        vim.o.background = "dark"

        vim.cmd.colorscheme("gruvbox-material")
      end,
    },
    -- }}}
    -- lualine.nvim {{{
    -- Statusline/tabline
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup()
      end,
    },
    -- }}}
    -- mason {{{
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
    -- }}}
    -- mason-lspconfig.nvim {{{
    {
      "mason-org/mason-lspconfig.nvim",
      config = function()
        require("mason-lspconfig").setup()
      end,
    },
    -- }}}
    -- nvim-autopairs {{{
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true,
      -- use opts = {} for passing setup options
      -- this is equivalent to setup({}) function
    },
    -- }}}
    -- nvim-cmp {{{
    -- A completion plugin
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "quangnguyen30192/cmp-nvim-ultisnips",
        "hrsh7th/cmp-path",
        "micangl/cmp-vimtex",
      },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "ultisnips" },
            { name = "nvim_lua" },
            { name = "vimtex" },
            { name = "path" },
            { name = "buffer" },
          }),
          snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
              vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            -- Accept currently selected item. Set `select` to `false`
            -- to only confirm explicitly selected items.
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          }),
          window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
          },
          view = {
            entries = "custom", -- can be "custom", "wildmenu" or "native"
          },
        })
      end,
    },
    -- }}}
    -- nvim-dap {{{
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
    --}}}
    -- nvim-lint {{{
    {
      "mfussenegger/nvim-lint",
      config = function()
        require("lint").linters_by_ft = {
          lua = { "luac" },
          markdown = { "markdownlint" },
          python = { "ruff" },
          sh = { "shellcheck" },
        }

        vim.diagnostic.config({
          -- virtual_text = true,
          -- virtual_lines = false,
          virtual_text = { current_line = false },
          virtual_lines = { current_line = true },
          -- float = {
          --   focusable = true, -- Whether the float window should be focusable
          --   style = "minimal", -- Optionally set the float style (can be 'minimal' or 'normal')
          --   -- border = "rounded", -- Optionally set a border style for the float
          -- },
        })

        vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave", "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      end,
    },
    -- }}}
    -- nvim-lspconfig {{{
    {
      "neovim/nvim-lspconfig",
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.lsp.config("bashls", { capabilities = capabilities })
        vim.lsp.config("lua_ls", {
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })
        vim.lsp.config("marksman", { capabilities = capabilities })
        vim.lsp.config("texlab", { capabilities = capabilities })
        vim.lsp.config("jedi_language_server", { capabilities = capabilities })
        vim.lsp.config("html", { capabilities = capabilities })
        vim.lsp.config("jsonls", { capabilities = capabilities })
        vim.lsp.config("cssls", { capabilities = capabilities })

        vim.lsp.enable({
          "bashls",
          "lua_ls",
          "marksman",
          "texlab",
          "jedi_language_server",
          "html",
          "jsonls",
          "cssls",
        })
      end,
    },
    -- }}}
    -- nvim-tree {{{
    -- File tree explorer
    {
      "nvim-tree/nvim-tree.lua",
      init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
      end,
      config = function()
        require("nvim-tree").setup({
          view = {
            width = 31,
            number = true,
            relativenumber = true,
          },
        })

        vim.keymap.set("n", "<Leader>n", ":NvimTreeToggle<CR>:wincmd p<CR>", { noremap = true, silent = true })
      end,
    },
    -- }}}
    -- nvim-treesitter {{{
    -- advanced higlighting
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = false },
        })
      end,
    },
    -- }}}
    -- peek.nvim {{{
    -- markdown previewer
    {
      "toppair/peek.nvim",
      event = { "VeryLazy" },
      build = "deno task --quiet build:fast",
      config = function()
        require("peek").setup({
          auto_load = true, -- whether to automatically load preview when
          -- entering another markdown buffer
          close_on_bdelete = true, -- close preview window on buffer delete

          syntax = true, -- enable syntax highlighting, affects performance

          theme = "dark", -- 'dark' or 'light'

          update_on_change = true,

          app = "browser", -- 'webview', 'browser', string or a table of strings
          -- explained below

          filetype = { "markdown" }, -- list of filetypes to recognize as markdown

          -- relevant if update_on_change is true
          throttle_at = 200000, -- start throttling when file exceeds this
          -- amount of bytes in size
          throttle_time = "auto", -- minimum amount of time in milliseconds
          -- that has to pass before starting new render
        })
        vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
      end,
    },
    -- }}}
    -- tagbar {{{
    -- Dispalys tags
    {
      "preservim/tagbar",
      init = function()
        vim.g.tagbar_width = 40
        vim.keymap.set("n", "<Leader>tb", ":TagbarToggle<CR>", { noremap = true })
      end,
    },
    -- }}}
    -- ultisnips {{{
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
    -- }}}
    -- vimtex {{{
    -- LaTeX
    {
      "lervag/vimtex",
      lazy = false, -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "general"
      end,
    },
    -- }}}
  },
  -- Other settings {{{
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = {
    colorscheme = { "gruvbox-material" },
    missing = true,
  },
  pkg = {
    -- the first package source that is found for a plugin will be used.
    sources = {
      "lazy",
      "rockspec", -- will only be used when rocks.enabled is true
      "packspec",
    },
  },
  rocks = {
    enabled = false,
  },
  -- }}}
})
-- }}}
-- }}}

vim.cmd([[
syntax on
filetype plugin indent on
]])

--
-- My own notes
--
-- {{{
-- Some LSP servers needed:
--   Install manually:
--   - https://github.com/latex-lsp/texlab
--   Listed in packages:
--   - https://github.com/iamcco/vim-language-server
--   - https://github.com/bash-lsp/bash-language-server
--   - https://github.com/artempyanykh/marksman
-- npm packages:
--   - bash-language-server
--   - htmlhint
--   - markdownlint-cli
--   - prettier
--   - vim-language-server
-- pip packages
--   - autoimport
--   - bandit
--   - black
--   - isort
--   - mypy
--   - ruff
--   - vim-vint
-- Snap packages
--   - marksman
--   - shellcheck
--   - shfmt
-- Package manager
--   - universal-ctags
-- }}}
