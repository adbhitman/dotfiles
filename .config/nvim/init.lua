--
-- COMMON
--
-- {{{
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

vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

vim.o.autoread = true
vim.o.splitright = true

vim.cmd([[
syntax on
filetype plugin indent on
]])

-- sets tabs to spaces
vim.o.tabstop = 4 -- Size of TAB as spaces=true
vim.o.softtabstop = 4 -- Sets the number of columns for a TAB=true
vim.o.shiftwidth = 4 -- Indents will have a width of 4=true
vim.o.expandtab = true -- Expand TABs to spaces=true
vim.o.autoindent = true -- Copy indent from current line when starting a new line.=true
vim.o.smartindent = true

vim.opt.backspace = { "indent", "eol", "start" }
vim.o.joinspaces = false

vim.cmd([[
setlocal omnifunc=syntaxcomplete#Complete
]])

vim.opt.completeopt = { "menuone", "preview", "popup", "fuzzy" }

vim.o.history = 1000
vim.opt.messagesopt = { "hit-enter", "history:1000" }
--vim.o.autochdir=true

vim.o.wildmenu = true
vim.opt.wildmode = { "longest", "list" }
vim.opt.wildignore = { "*.docx", "*.jpg", "*.png", "*.gif", "*.pdf", "*.pyc", "*.exe", "*.flv", "*.img", "*.xlsx" }

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
vim.keymap.set("n", "<F1>", ":nohlsearch<CR>", { noremap = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
vim.keymap.set("v", "<C-c>", "+y", { noremap = true })
vim.keymap.set("n", "Q", "<Nop>", { noremap = true, silent = true })

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

--
-- PLUGINS
--
-- {{{
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
-- {{{
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      -- conform.nvim {{{
      -- code formatter
      "stevearc/conform.nvim",
      event = {},
      cmd = { "ConformInfo" },
      keys = {
        {
          -- Customize or remove this keymap to your liking
          --     vim.keymap.set('n', "<Leader><Leader>f", ":Format<CR>", {noremap=true})
          "<Leader><Leader>f",
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
        },
        -- Set default options
        default_format_opts = {
          lsp_format = "fallback",
        },
        -- Set up format-on-save
        -- format_on_save = { timeout_ms = 500 },
        -- Customize formatters
        formatters = {
          shfmt = {
            prepend_args = { "-i", "2" },
          },
        },
      },
      init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      end,
      -- }}}
    },
    {
      -- fzf {{{
      -- Fuzzy search
      "junegunn/fzf",
      -- }}}
    },
    {
      -- fzf.vim {{{
      "junegunn/fzf.vim",
      init = function()
        vim.g.fzf_vim = {} -- Initializes fzf_vim
        vim.g.fzf_command_prefix = "Fzf"
      end,
      config = function()
        vim.keymap.set("n", "<Leader><Leader>b", ":FzfBuffers<CR>", { noremap = true })
        vim.keymap.set("n", "<Leader><Leader>c", ":FzfCommands<CR>", { noremap = true })
        vim.keymap.set("n", "<Leader><Leader>s", ":FzfFiles<CR>", { noremap = true })
        vim.keymap.set("n", "q:", ":FzfHistory:<CR>", { noremap = true })
      end,
      -- }}}
    },
    {
      -- gruvbox-material {{{
      -- Color themes
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
      -- }}}
    },
    {
      -- lualine.nvim {{{
      -- Statusline/tabline
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup()
      end,
      -- }}}
    },
    {
      -- mason {{{
      "williamboman/mason.nvim",
      config = function()
        require("mason").setup()
      end,
      -- }}}
    },
    {
      -- mason-lspconfig.nvim {{{
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require("mason-lspconfig").setup()
        -- require("mason-lspconfig").setup_handlers {
        --     -- The first entry (without a key) will be the default handler
        --     -- and will be called for each installed server that doesn't have
        --     -- a dedicated handler.
        --     function (server_name) -- default handler (optional)
        --         require("lspconfig")[server_name].setup {}
        --     end,
        --     -- Next, you can provide a dedicated handler for specific servers.
        --     -- For example, a handler override for the `rust_analyzer`:
        --     ["rust_analyzer"] = function ()
        --         require("rust-tools").setup {}
        --     end
        -- }
      end,
      -- }}}
    },
    {
      -- nvim-autopairs {{{
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true,
      -- use opts = {} for passing setup options
      -- this is equivalent to setup({}) function
      -- }}}
    },
    {
      -- nvim-cmp {{{
      -- A completion plugin
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
        require("cmp").setup({
          sources = {
            { name = "buffer" },
            { name = "nvim-lsp" },
            { name = "nvim-lua" },
            { name = "cmp-nvim-ultisnips" },
            { name = "path" },
            { name = "vimtex" },
          },
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
          }),
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          view = {
            entries = "custom", -- can be "custom", "wildmenu" or "native"
          },
        })
      end,
      -- }}}
    },
    {
      -- nvim-dap {{{
      -- debugger
      "mfussenegger/nvim-dap",
      -- }}}
    },
    {
      -- nvim-dap-ui {{{
      -- UI for nvim-dap
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
      },
      --}}}
    },
    {
      -- nvim-lint {{{
      "mfussenegger/nvim-lint",
      config = function()
        require("lint").linters_by_ft = {
          lua = { "luac" },
          markdown = { "markdownlint" },
          python = { "ruff" },
          sh = { "shellcheck" },
        }

        vim.diagnostic.config({
          virtual_text = true,
          underline = true,
          update_in_insert = true,
        })

        vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave", "BufWritePost" }, {
          callback = function()
            require("lint").try_lint()
          end,
        })
      end,
      -- }}}
    },
    {
      -- nvim-lspconfig {{{
      "neovim/nvim-lspconfig",
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")

        lspconfig.bashls.setup({ capabilities = capabilities })
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })
        lspconfig.marksman.setup({ capabilities = capabilities })
        lspconfig.texlab.setup({ capabilities = capabilities })
      end,
      -- }}}
    },
    {
      -- nvim-tree {{{
      -- File tree explorer
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

        vim.keymap.set("n", "<Leader><Leader>n", ":NvimTreeToggle | wincmd p<CR>", { noremap = true, silent = true })
      end,
      -- }}}
    },
    {
      -- tagbar {{{
      -- Dispalys tags
      "preservim/tagbar",
      init = function()
        vim.g.tagbar_width = 40
        vim.keymap.set("n", "<Leader><Leader>tb", ":TagbarToggle<CR>", { noremap = true })
      end,
      -- }}}
    },
    {
      -- ultisnips {{{
      -- Allows to write own snippets to spesific languages or commonly all
      "SirVer/ultisnips",
      init = function()
        -- These are needed for not to conflict with YCM
        -- https://github.com/ycm-core/YouCompleteMe/wiki/FAQ#ycm-conflicts-with-ultisnips-tab-key-usage
        -- UltiSnips triggering :
        --  - ctrl-j to expand
        --  - ctrl-j to go to next tabstop
        --  - ctrl-k to go to previous tabstop
        vim.g.UltiSnipsExpandTrigger = "<C-j>"
        vim.g.UltiSnipsJumpForwardTrigger = "<C-j>"
        vim.g.UltiSnipsJumpBackwardTrigger = "<C-k>"
      end,
      -- }}}
    },
    {
      -- vimtex {{{
      -- LaTeX
      "lervag/vimtex",
      lazy = false, -- we don't want to lazy load VimTeX
      -- tag = "v2.15", -- uncomment to pin to a specific release
      init = function()
        vim.api.nvim_create_augroup("vimtex_ycm", {})

        vim.api.nvim_create_autocmd({ "BufEnter" }, {
          group = "vimtex_ycm",
          callback = function()
            -- Check if the variable 'g:ycm_semantic_triggers' exists
            if not vim.g.ycm_semantic_triggers then
              vim.g.ycm_semantic_triggers = {}
            end

            -- Create an autocommand for the 'VimEnter' event
            vim.api.nvim_create_autocmd("VimEnter", {
              callback = function()
                -- Check if vimtex is loaded
                if vim.g.vimtex and vim.g.vimtex.re then
                  -- Make sure the VimTeX re table is accessible
                  vim.g.ycm_semantic_triggers.tex = vim.g.vimtex.re.youcompleteme
                else
                  print("VimTeX is not loaded or 're' field is missing!")
                end
              end,
            })
          end,
        })
      end,
      -- }}}
    },
    {
      -- vim-gitgutter {{{
      -- Git diff markers
      "airblade/vim-gitgutter",
      config = function()
        vim.keymap.set("n", "<Leader><Leader>gg", ":GitGutterToggle<CR>", { noremap = true })
      end,
      -- }}}
    },
  },
  -- Other settings {{{
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = {
    colorscheme = { "gruvbox-material" },
    missing = false,
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
