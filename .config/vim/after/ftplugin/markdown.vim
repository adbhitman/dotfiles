if exists("b:did_ftplugin_markdown")
    finish
endif
let b:did_ftplugin_markdown=1

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal textwidth=80

let b:ale_fix_on_save=1
