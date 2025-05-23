vim.cmd([[
nnoremap <Localleader>f :call FoldColumnToggle()<cr>

function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction

nnoremap <leader>q :call QuickFixToggle()<cr>

let g:quickfix_is_open=0

function! QuickFixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open=0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window=winnr()
        copen
        let g:quickfix_is_open=1
    endif
endfunction
]])
