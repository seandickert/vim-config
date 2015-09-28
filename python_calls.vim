if !has('python')
    finish
endif

python import sys
python import vim

function! CommentBlock()
    python sys.argv = ["comment"]
    pyfile /Users/seandickert/.vim/python_imp.py
endfunc

function! UnCommentBlock()
    python sys.argv = ["uncomment"]
    pyfile /Users/seandickert/.vim/python_imp.py
endfunc
    
function! FormatList(quote_char)
    python sys.argv = ["list", vim.eval("a:quote_char")]
    pyfile /Users/seandickert/.vim/python_imp.py
endfunc

function! FormatDict(quote_char)
    python sys.argv = ["dict", vim.eval("a:quote_char")]
    pyfile /Users/seandickert/.vim/python_imp.py
endfunc

function! OpenChar(quote_char)
    python sys.argv = ["open_char", vim.eval("a:quote_char")]
    pyfile /Users/seandickert/.vim/python_imp.py
    return ""
endfunc

function! JumpChar(quote_char)
    python sys.argv = ["jump_char", vim.eval("a:quote_char")]
    pyfile /Users/seandickert/.vim/python_imp.py
    return ""
endfunc

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
