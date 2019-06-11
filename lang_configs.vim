" If you use pyhon you can chang the file of vimrc/plugins_configs.vim
" and decomment the python line to open the plugin
" All of the plugin in this file can be replace by other completion tools
" Such as Snippet-mate, YoucompleteMe

""""""""""""""""""""""""""""""
" => UltiSnippet
""""""""""""""""""""""""""""""
let g:snips_author="your name"
let g:snips_email="your email"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => jedi-vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:jedi#rename_command = '<leader>jr'
let g:jedi#usages_command = '<leader>ju'
let g:jedi#goto_command = '<leader>jd'
let g:jedi#goto_assignments_command = '<leader>ja'
let g:jedi_motion = 1
let g:jedi#popup_on_dot = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => autopep8
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType python noremap <buffer> <F7> :call Autopep8()<CR>
let g:autopep8_aggressive=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => superTab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"


" If you use go you can chang the file of vimrc/plugins_configs.vim
" and decomment the go line to open the plugin
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-go
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

au FileType go nmap <Leader>jp <Plug>(go-implements)
au FileType go nmap <Leader>ji <Plug>(go-info)
au FileType go nmap K  <Plug>(go-doc)
au FileType go nmap <Leader>jd <Plug>(go-def-tab)
au FileType go nmap <Leader>jr <Plug>(go-rename)　　
let g:go_fmt_command="goimports"
let g:go_fmt_autosave=1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
