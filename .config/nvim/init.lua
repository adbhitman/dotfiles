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

vim.g.mapleader=''
vim.g.maplocalleader=''

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
--set cursorcolumn

vim.cmd([[
augroup setcolorcolumn
    autocmd!
    autocmd BufEnter * if !&textwidth | setlocal textwidth=80
    autocmd BufWinEnter * setlocal colorcolumn=+1
augroup END

highlight ColorColumn ctermbg=0 guibg=lightgrey
]])

vim.o.spell=true
--vim.o.spelllang='en'
-- }}}

vim.cmd([[
" Mappings {{{
nnoremap <F1> :nohlsearch<CR>
inoremap jk <Esc>
nnoremap <F8> :w \| call ShowCodeOutput("python3")<CR>
inoremap <F8> <Esc>:w \| call ShowCodeOutput("python3")<CR>
" nnoremap <buffer> <localleader>b :call MyShowCode()<cr>

setlocal mouse=a

nnoremap <leader>tm :call ToggleMouse()<CR>
function! ToggleMouse()
    if ( &mouse ==? '' )
        setlocal mouse=a
    else
        setlocal mouse=""
    endif
    echo ':call ToggleMouse(): value:' . &mouse
endfunction

vnoremap <C-c> "+y
map Q <Nop>

function! ShowCodeOutput(compiler)
    let pattern='__' . bufname('%') . '_output__'
    let windowNr=bufwinnr(pattern)

    let code=system(a:compiler . ' ' . bufname('%') .' 2>&1')

    if windowNr > 0
        execute windowNr 'wincmd w'
    else
        execute 'vsplit' pattern
    endif

    normal! ggdG
    setlocal buftype=nofile

    call append(0, split(code, '\v\n'))
    execute 'wincmd p'
endfunction
" }}}
" }}}
]])


vim.cmd([[
"
" PLUGINS
"
" {{{
" Making manually helptags
" commandline:
"   vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
" in VIM:
"   helptags ~/.vim/pack/vendor/start/nerdtree/doc


"
" junegunn/vim-plug
"
" {{{
" autoload and install needed plugins
"
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')

" Linter and fixer, lsp support
Plug 'dense-analysis/ale'

" Fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Color themes
Plug 'sainnhe/gruvbox-material'

" Statusline/tabline
Plug 'itchyny/lightline.vim'

" File tree explorer
Plug 'preservim/nerdtree'

" Dispalys tags
Plug 'preservim/tagbar'

" Allows to write own snippets to spesific languages or commonly all
Plug 'SirVer/ultisnips'

" Debugger for VIM
Plug 'puremourning/vimspector'

" LaTeX
Plug 'lervag/vimtex'

" TODO Asynchronous compiler
"Plug 'tpope/vim-dispatch'

" Git diff markers
Plug 'airblade/vim-gitgutter'

" Jinja2 syntax
Plug 'Glench/Vim-Jinja2-Syntax'

" Autocompletion engine for VIM
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --java-completer' }

call plug#end()
" }}}


"
" ale
"
" {{{
" Needs flake8, pylint etc. packages to python to use linting and checking:
" pip install flake8 black
"
let g:ale_linters =
  \ {
  \   'java': [],
  \   'markdown': [ 'markdownlint', 'marksman' ],
  \   'python': [ 'ruff', 'mypy' ],
  \   'sh': [ 'shell', 'shellcheck' ],
  \   'tex': [ 'texlab' ],
  \ }
let g:ale_fixers =
  \ {
  \    '*': [ 'trim_whitespace' ],
  \   'css': [ 'prettier' ],
  \   'html': [ 'prettier' ],
  \   'javascript': [ 'prettier' ],
  \   'json': [ 'prettier' ],
  \   'markdown': [ 'prettier' ],
  \   'python': [ 'ruff_format' ],
  \   'sh': [ 'shfmt' ],
  \   'tex': [ 'latexindent' ],
  \ }
"let g:ale_linters_ignore = {'markdown': ['marksman']}
"let g:ale_completion_enabled=1
"let g:ale_fix_on_save = 1
"let g:ale_linters_explicit = 1
"let g:ale_python_ruff_options='--config ~/.ruff.toml'
let g:ale_markdown_markdownlint_options='--disable MD013 --'
let g:ale_python_mypy_options='--ignore-missing-imports'
let g:ale_sh_shfmt_options='--indent 4'

nnoremap <Leader><Leader>f :ALEFix<CR>
" }}}


"
" comment, VIM native
"
" {{{
if !has('nvim')
    packadd comment
endif
" }}}


"
" fzf.vim
"
" {{{
let g:fzf_vim = {}
let g:fzf_vim.command_prefix = 'Fzf'
nnoremap q: :FzfHistory:<CR>
nnoremap <Leader><Leader>b :FzfBuffers<CR>
nnoremap <Leader><Leader>c :FzfCommands<CR>
nnoremap <Leader><Leader>s :FzfFiles<CR>
" }}}


"
" gruvbox-material
"
" {{{
if has('termguicolors')
    set termguicolors
endif
set background=dark
let g:gruvbox_material_background='hard'
let g:gruvbox_material_foreground='mix'
colorscheme gruvbox-material

" make undercurl work in a terminal (like with spell)
let &t_Ce = "\e[4:0m"
let &t_Cs = "\e[4:3m"
" }}}


"
" HelpToc, VIM's native
"
" {{{
if !has('nvim')
    packadd helptoc
endif
" }}}


"
" lightline.vim
"
" {{{
let g:lightline = { 'colorscheme' : 'gruvbox_material' }
" }}}


"
" nerdtree
"
" {{{
let NERDTreeWinSize=31
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1

nnoremap <silent> <Leader><Leader>n :NERDTreeToggle \| wincmd p<CR>
nnoremap <Leader><Leader>mks :NERDTreeClose \| mksession! \| NERDTree \| wincmd p<CR>
" }}}


"
" tagbar
"
" {{{
" requires ctags:
"   sudo apt install universal-ctags
"
let g:tagbar_width=40
nnoremap <Leader><Leader>tb :TagbarToggle<CR>
" }}}


"
" ultisnips
"
" {{{
" These are needed for not to conflict with YCM
" https://github.com/ycm-core/YouCompleteMe/wiki/FAQ#ycm-conflicts-with-ultisnips-tab-key-usage
" UltiSnips triggering :
"  - ctrl-j to expand
"  - ctrl-j to go to next tabstop
"  - ctrl-k to go to previous tabstop
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
" }}}


"
" vimspector
"
" {{{
"let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-java-debug', 'vscode-bash-debug' ]
let g:ycm_semantic_triggers =  {
    \ 'VimspectorPrompt': [ '.', '->', ':', '<' ]
\ }

"let g:vimspector_enable_mappings = 'HUMAN'
nmap <F5> <Plug>VimspectorContinue
nmap <F3> <Plug>VimspectorStop
nmap <F4> <Plug>VimspectorRestart
nmap <F6> <Plug>VimspectorPause
nmap <F9> <Plug>VimspectorToggleBreakpoint
nmap <leader><F9> <Plug>VimspectorToggleConditionalBreakpoint
nmap <leader><F8> <Plug>VimspectorRunToCursor
nmap <F10> <Plug>VimspectorStepOver
nmap <F11> <Plug>VimspectorStepInto
nmap <F12> <Plug>VimspectorStepOut

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval
" }}}


"
" vimtex
"
" {{{
augroup vimtex_ycm
    au!
    if !exists('g:ycm_semantic_triggers')
        let g:ycm_semantic_triggers = {}
    endif
    au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme
augroup END
" }}}


"
" vim-gitgutter
"
" {{{
nnoremap <Leader><Leader>gg :GitGutterToggle<CR>
" }}}


"
" YouCompleteMe
"
" {{{
" Here goes your own language servers to other languages
let g:ycm_language_server =
  \ [
  \   {
  \     'name': 'vim',
  \     'cmdline': [ 'vim-language-server', '--stdio' ],
  \     'filetypes': [ 'vim' ],
  \   },
  \   {
  \     'name': 'bash',
  \     'cmdline': [ 'bash-language-server', 'start' ],
  \     'filetypes': [ 'sh' ],
  \   },
  \   {
  \     'name': 'marksman',
  \     'cmdline': [ 'marksman', 'server' ],
  \     'filetypes': [ 'markdown' ],
  \   },
  \ ]
let g:ycm_filetype_blacklist = {
      \ 'tagbar': 1,
      \ 'notes': 1,
      \ 'netrw': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'leaderf': 1,
      \ 'mail': 1
      \}
      "\ 'markdown': 1,
let g:ycm_autoclose_preview_window_after_completion=1
set updatetime=100 " in ms,  making autohover appear faster
let g:ycm_auto_hover=''
nnoremap KH <plug>(YCMHover)
nnoremap KK :vertical 85ShowDocWithSize<CR>

command -count ShowDocWithSize
  \ let g:ph=&previewheight
  \ <bar> set previewheight=<count>
  \ <bar> <mods> YcmCompleter GetDoc
  \ <bar> let &previewheight=g:ph
" }}}
" }}}


"
" My own notes
"
" {{{
" Some LSP servers needed:
"   Install manually:
"   - https://github.com/latex-lsp/texlab
"   Listed in packages:
"   - https://github.com/iamcco/vim-language-server
"   - https://github.com/bash-lsp/bash-language-server
"   - https://github.com/artempyanykh/marksman
" npm packages:
"   - bash-language-server
"   - htmlhint
"   - markdownlint-cli
"   - prettier
"   - vim-language-server
" pip packages
"   - autoimport
"   - bandit
"   - black
"   - isort
"   - mypy
"   - ruff
"   - vim-vint
" Snap packages
"   - marksman
"   - shellcheck
"   - shfmt
" Package manager
"   - universal-ctags
" }}}
]])
