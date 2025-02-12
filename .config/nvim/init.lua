--
-- COMMON
--
-- {{{
-- Common settings {{{
vim.o.compatible=false
vim.o.number=true
vim.o.relativenumber=true
vim.o.hlsearch=true
vim.o.incsearch=true
vim.o.ignorecase=true
vim.o.smartcase=true
vim.o.encoding='utf-8'
--vim.o.fileformat=unix
--vim.o.fileencoding=utf-8

vim.g.mapleader='\\'
vim.g.maplocalleader='\\'

vim.o.autoread=true
vim.o.splitright=true

vim.cmd([[
syntax on
filetype plugin indent on
]])

-- sets tabs to spaces
vim.o.tabstop=4     -- Size of TAB as spaces=true
vim.o.softtabstop=4 -- Sets the number of columns for a TAB=true
vim.o.shiftwidth=4  -- Indents will have a width of 4=true
vim.o.expandtab=true     -- Expand TABs to spaces=true
vim.o.autoindent=true    -- Copy indent from current line when starting a new line.=true
vim.o.smartindent=true

vim.opt.backspace={'indent','eol','start'}
vim.o.joinspaces=false

vim.cmd([[
setlocal omnifunc=syntaxcomplete#Complete
]])

vim.opt.completeopt={'menuone','preview','popup','fuzzy'}

vim.o.history=1000
vim.opt.messagesopt={'hit-enter','history:1000'}
--vim.o.autochdir=true

vim.o.wildmenu=true
vim.opt.wildmode={'longest','list'}
vim.opt.wildignore={'*.docx','*.jpg','*.png','*.gif','*.pdf','*.pyc','*.exe','*.flv','*.img','*.xlsx'}

vim.o.hidden=true
vim.o.showcmd=true
--vim.o.title=true
vim.o.laststatus=2

vim.o.timeout=true
vim.o.ttimeoutlen=100
--vim.o.ruler=true
vim.o.scrolloff=5

vim.o.cursorline=true
--vim.o.cursorcolumn=true

vim.api.nvim_create_augroup("setcolorcolumn", {})

vim.api.nvim_create_autocmd({"BufEnter","BufWinEnter"}, {
    group="setcolorcolumn",
    callback=function()
        if vim.bo.textwidth==0 then
            vim.bo.textwidth=80
        end

        vim.wo.colorcolumn="+1"
    end
})

vim.api.nvim_set_hl(0, "ColorColumn", {ctermbg=0, guibg=lightgrey})

vim.o.spell=false
--vim.o.spelllang='en'
-- }}}

-- Mappings {{{
vim.keymap.set("n", "<F1>", ":nohlsearch<CR>", {noremap=true})
vim.keymap.set("i", "jk", "<Esc>", {noremap=true})
vim.keymap.set("v", "<C-c>", "+y", {noremap=true})
vim.keymap.set("n", "Q", "<Nop>", { noremap = true, silent = true })

vim.opt_local.mouse="a"


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
    local pattern='__' .. vim.fn.bufname('%') .. '_output__'
    local windowNr=vim.fn.bufwinnr(pattern)

    local code=vim.fn.system(compiler .. ' ' .. vim.fn.bufname('%') .. ' 2>&1')

    if windowNr > 0 then
        vim.cmd("execute" .. windowNr .. " 'wincmd w'")
    else
        vim.cmd("execute 'vsplit " .. pattern .. "'")
    end

    vim.cmd("normal! ggdG")
    vim.opt_local.buftype="nofile"

    vim.fn.append(0, vim.fn.split(code, "\n"))
    vim.cmd("execute 'wincmd p'")
end


vim.keymap.set("n", "<Leader>tm", ToggleMouse, {noremap=true})
vim.keymap.set({"n"}, "<F8>", ":w | lua ShowCodeOutput('python3')<CR>", {noremap=true})
vim.keymap.set({"i"}, "<F8>", "<Esc>:w | lua ShowCodeOutput('python3')<CR>", {noremap=true})
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
            -- ale {{{
            -- Linter and fixer, lsp support
            'dense-analysis/ale',
            config = function()
                vim.g.ale_linters =
                {
                    java= {},
                    markdown= {'markdownlint', 'marksman'},
                    python= {'ruff', 'mypy'},
                    sh={'shell', 'shellcheck'},
                    tex={'texlab'},
                }
                vim.g.ale_fixers = {
                    ['*']= {'trim_whitespace'},
                    css= {'prettier'},
                    html= {'prettier'},
                    javascript= {'prettier'},
                    json= {'prettier'},
                    markdown= {'prettier'},
                    python= {'ruff_format'},
                    sh= {'shfmt'},
                    tex= {'latexindent'},
                }

                -- vim.g.ale_linters_ignore = {markdown= {'marksman'}}
                -- vim.g.ale_completion_enabled=1
                -- vim.g.ale_fix_on_save = 1
                -- vim.gale_linters_explicit = 1
                -- vim.g.ale_python_ruff_options='--config ~/.ruff.toml'
                vim.g.ale_markdown_markdownlint_options='--disable MD013 --'
                vim.g.ale_python_mypy_options='--ignore-missing-imports'
                vim.g.ale_sh_shfmt_options='--indent 4'

                vim.keymap.set('n', "<Leader><Leader>f", ":ALEFix<CR>", {noremap=true})
            end
            -- }}}
        },
        {
         -- fzf {{{
         -- Fuzzy search
         'junegunn/fzf',
            -- }}}
        },
        {
            -- fzf.vim {{{
            'junegunn/fzf.vim',
            init = function()
                vim.g.fzf_vim = {}  -- Initializes fzf_vim
                vim.g.fzf_command_prefix = 'Fzf'
            end,
            config=function()
                vim.keymap.set('n', '<Leader><Leader>b', ':FzfBuffers<CR>', { noremap = true })
                vim.keymap.set('n', '<Leader><Leader>c', ':FzfCommands<CR>', { noremap = true })
                vim.keymap.set('n', '<Leader><Leader>s', ':FzfFiles<CR>', { noremap = true })
                vim.keymap.set('n', 'q:', ':FzfHistory:<CR>', { noremap = true })
            end
            -- }}}
        },
        {
         -- gruvbox-material {{{
         -- Color themes
         'sainnhe/gruvbox-material',
         lazy = false,
         priority = 1000,
         config = function()
             if vim.fn.has('termguicolors') == 1 then
                 vim.o.termguicolors = true
             end

             vim.g.gruvbox_material_background='hard'
             vim.g.gruvbox_material_foreground='mix'
             vim.o.background='dark'

             vim.cmd.colorscheme('gruvbox-material')
         end
         -- }}}
        },
        {
         -- lightline.vim {{{
         -- Statusline/tabline
         'itchyny/lightline.vim',
         init=function()
             vim.g.lightline = { colorscheme = 'gruvbox_material' }
         end
         -- }}}
        },
        {
         -- nvim-lspconfig {{{
            'neovim/nvim-lspconfig',
         -- }}}
        },
        {
         -- nvim-tree {{{
         -- File tree explorer
         'nvim-tree/nvim-tree.lua',
         init=function()
             vim.g.loaded_netrw = 1
             vim.g.loaded_netrwPlugin = 1
         end,
         config=function()
             require("nvim-tree").setup({
                 view = {
                     width = 31,
                     number = true,
                     relativenumber = true,
                 },
             })

             vim.keymap.set('n', "<Leader><Leader>n", ":NvimTreeToggle | wincmd p<CR>", {noremap=true, silent=true})
         end,
         -- }}}
        },
        {
            -- tagbar {{{
            -- Dispalys tags
            'preservim/tagbar',
            init=function()
                vim.g.tagbar_width=40
                vim.keymap.set('n', '<Leader><Leader>tb', ':TagbarToggle<CR>', {noremap=true})
            end
            -- }}}
        },
        {
            -- ultisnips {{{
            -- Allows to write own snippets to spesific languages or commonly all
            'SirVer/ultisnips',
            init=function()
                -- These are needed for not to conflict with YCM
                -- https://github.com/ycm-core/YouCompleteMe/wiki/FAQ#ycm-conflicts-with-ultisnips-tab-key-usage
                -- UltiSnips triggering :
                --  - ctrl-j to expand
                --  - ctrl-j to go to next tabstop
                --  - ctrl-k to go to previous tabstop
                vim.g.UltiSnipsExpandTrigger = '<C-j>'
                vim.g.UltiSnipsJumpForwardTrigger = '<C-j>'
                vim.g.UltiSnipsJumpBackwardTrigger = '<C-k>'
            end
            -- }}}
        },
        {
            -- vimspector {{{
            -- Debugger for VIM
            'puremourning/vimspector',
            config = function()
                -- vim.g.vimspector_install_gadgets = { 'debugpy', 'vscode-java-debug', 'vscode-bash-debug' }

                vim.g.ycm_semantic_triggers = {
                    VimspectorPrompt = { '.', '->', ':', '<' }
                }

                -- vim.g.vimspector_enable_mappings = 'HUMAN'
                vim.keymap.set('n', '<F5>', '<Plug>VimspectorContinue', { noremap = true, silent = true })
                vim.keymap.set('n', '<F3>', '<Plug>VimspectorStop', { noremap = true, silent = true })
                vim.keymap.set('n', '<F4>', '<Plug>VimspectorRestart', { noremap = true, silent = true })
                vim.keymap.set('n', '<F6>', '<Plug>VimspectorPause', { noremap = true, silent = true })
                vim.keymap.set('n', '<F9>', '<Plug>VimspectorToggleBreakpoint', { noremap = true, silent = true })
                vim.keymap.set('n', '<leader><F9>', '<Plug>VimspectorToggleConditionalBreakpoint', { noremap = true, silent = true })
                vim.keymap.set('n', '<leader><F8>', '<Plug>VimspectorRunToCursor', { noremap = true, silent = true })
                vim.keymap.set('n', '<F10>', '<Plug>VimspectorStepOver', { noremap = true, silent = true })
                vim.keymap.set('n', '<F11>', '<Plug>VimspectorStepInto', { noremap = true, silent = true })
                vim.keymap.set('n', '<F12>', '<Plug>VimspectorStepOut', { noremap = true, silent = true })
                vim.keymap.set('x', '<Leader>di', '<Plug>VimspectorBalloonEval', { noremap = true, silent = true })
            end
            --}}}
        },
        {
            -- vimtex {{{
            -- LaTeX
            "lervag/vimtex",
            lazy = false,     -- we don't want to lazy load VimTeX
            -- tag = "v2.15", -- uncomment to pin to a specific release
            init = function()
                vim.api.nvim_create_augroup("vimtex_ycm", {})

                vim.api.nvim_create_autocmd({'BufEnter'}, {
                    group="vimtex_ycm",
                    callback=function()
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
                            end
                        })
                    end
                })
            end
            -- }}}
        },
        {
            -- vim-gitgutter {{{
            -- Git diff markers
            'airblade/vim-gitgutter',
            config=function()
                vim.keymap.set('n', '<Leader><Leader>gg', ':GitGutterToggle<CR>', {noremap=true})
            end
            -- }}}
        },
        {
            -- Vim-Jinja2-Syntax {{{
            -- Jinja2 syntax
            'Glench/Vim-Jinja2-Syntax',
            -- }}}
        },
        {
            -- YouCompleteMe {{{
            -- Autocompletion engine for VIM
            'ycm-core/YouCompleteMe',
            build = './install.py --java-completer',
            -- Setting up the YCM language server
            init=function()
                vim.g.ycm_language_server = {
                    {
                        name = 'vim',
                        cmdline = { 'vim-language-server', '--stdio' },
                        filetypes = { 'vim' }
                    },
                    {
                        name = 'bash',
                        cmdline = { 'bash-language-server', 'start' },
                        filetypes = { 'sh' }
                    },
                    {
                        name = 'marksman',
                        cmdline = { 'marksman', 'server' },
                        filetypes = { 'markdown' }
                    }
                }

                vim.g.ycm_filetype_blacklist = {
                    tagbar = 1,
                    notes = 1,
                    netrw = 1,
                    unite = 1,
                    text = 1,
                    vimwiki = 1,
                    pandoc = 1,
                    infolog = 1,
                    leaderf = 1,
                    -- markdown = 1,
                    mail = 1,
                }

                -- Enable auto-close of the preview window after completion
                vim.g.ycm_autoclose_preview_window_after_completion = 1

                -- Set up time for autohover (in ms,  making autohover appear faster)
                vim.o.updatetime = 100

                -- Configure YCM auto-hover
                vim.g.ycm_auto_hover = ''

                -- Key mappings
                vim.keymap.set('n', 'KH', '<Plug>(YCMHover)', { noremap = true, silent = true })
                vim.keymap.set('n', 'KK', ':vertical 85ShowDocWithSize<CR>', { noremap = true, silent = true })
                vim.api.nvim_create_user_command('ShowDocWithSize',
                function(opts)
                    vim.g.ph = vim.o.previewheight
                    vim.o.previewheight = opts.count
                    vim.cmd('YcmCompleter GetDoc')
                    vim.o.previewheight = vim.g.ph
                end,
                { nargs = 1 })
            end
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


-- My own notes {{{
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
