if !has('python')
    finish
endif

let g:py_file = fnamemodify(resolve(expand("<sfile>:p")), ":h")."/../libs/python_imp.py"
let g:exec_com = "pyfile ".g:py_file
python import sys
python import vim

function! CommentBlock()
    python sys.argv = ["comment"]
    execute g:exec_com
endfunc

function! UnCommentBlock()
    python sys.argv = ["uncomment"]
    execute g:exec_com
endfunc
    
function! FormatList(quote_char)
    python sys.argv = ["list", vim.eval("a:quote_char")]
    execute g:exec_com
endfunc

function! FormatDict(quote_char)
    python sys.argv = ["dict", vim.eval("a:quote_char")]
    execute g:exec_com
endfunc

function! OpenChar(quote_char)
    python sys.argv = ["open_char", vim.eval("a:quote_char")]
    execute g:exec_com
    return ""
endfunc

function! JumpChar(quote_char)
    python sys.argv = ["jump_char", vim.eval("a:quote_char")]
    execute g:exec_com
    return ""
endfunc

function! InsertIpdb()
    python sys.argv = ["insert_ipdb"]
    execute g:exec_com
    return ""
endfunc

function! DeleteIpdb()
    python sys.argv = ["delete_ipdb"]
    execute g:exec_com
    return ""
endfunc
    
augroup python_only
autocmd!
autocmd FileType python nnoremap <buffer> <silent> <F2> :call InsertIpdb()<cr>
autocmd FileType python nnoremap <buffer> <silent> <F3> :call DeleteIpdb()<cr>
augroup END

vnoremap <silent> cc :<C-u>call CommentBlock()<cr>
vnoremap <silent> cu :<C-u>call UnCommentBlock()<cr>
vnoremap <silent> ' :<C-u>call FormatList("'")<cr>
vnoremap <silent> " :<C-u>call FormatList("\"")<cr>
vnoremap <silent> { :<C-u>call FormatDict("'")<cr> 

inoremap ( <C-R>=OpenChar('(')<cr>
inoremap { <C-R>=OpenChar('{')<cr>
inoremap [ <C-R>=OpenChar('[')<cr>
inoremap ' <C-R>=OpenChar("'")<cr>
inoremap " <C-R>=OpenChar('"')<cr>

inoremap ) <C-R>=JumpChar('(')<cr>
inoremap } <C-R>=JumpChar('{')<cr>
inoremap ] <C-R>=JumpChar('[')<cr>
