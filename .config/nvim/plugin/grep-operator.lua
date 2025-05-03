vim.cmd([[
nnoremap <Localleader>g :set operatorfunc=GrepOperator<cr>g@
vnoremap <Localleader>g :<c-u>call GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let saved_unnamed_regiser = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    silent execute "grep! -R " .  shellescape(@@) . " ."
    copen

    let @@ = saved_unnamed_regiser
endfunction
]])
