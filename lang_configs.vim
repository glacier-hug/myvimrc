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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => YoucompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keymapping and some other congiuration
let g:ycm_python_binary_path = 'python3'
let g:ycm_key_invoke_completion = '<c-x><c-o>'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0
let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_complete_in_comments=1
let g:ycm_key_list_select_completion=['<c-n>', '<tab>']
let g:ycm_key_list_previous_completion=['<c-p>', '<S-tab>']
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
set completeopt=preview,longest,menu
let g:ycm_cache_omnifunc=0
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_complete_in_strings = 1
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR> 
nnoremap <leader>ja :YcmCompleter GoToDeclaration<CR> 
nnoremap <leader>ju :YcmCompleter GoToReferences<CR> 
nnoremap <leader>jt :YcmCompleter GetType<CR> 
nnoremap K :YcmCompleter GetDoc<CR> 
nnoremap <leader>jf :YcmCompleter FixIt<CR> 
nnoremap <leader>jr :YcmCompleter RefactorRename
let g:python_motion = 1
"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
