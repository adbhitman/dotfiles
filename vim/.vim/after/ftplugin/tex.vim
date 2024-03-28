if exists("b:did_ftplugin_tex")
    finish
endif
let b:did_ftplugin_tex=1

" Change autocomplete to run only one mode
nnoremap <buffer> <localleader>ss <plug>(vimtex-compile-ss)
setlocal formatoptions+=l
