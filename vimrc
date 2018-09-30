let g:pathogen_disabled = ['py_vim', 'dwm']

let mapleader=" "

"So pathogen sets the right runtime paths
execute pathogen#infect()
Helptags

filetype plugin on
"turn on syntax highlighting
syntax on

"indentLine settings
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_leadingSpaceEnabled = 1
"delimitmate settings
au FileType python let b:delimitMate_nesting_quotes = ['"']

"close tag settings for xml
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.xml"

"config settings for SimpylFold
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_docstring = 0
let g:SimpylFold_fold_import = 0
autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<
nnoremap , za
nnoremap < zA

"config settings for taglist
let g:Tlist_Process_File_Always = 1
let g:Tlist_Auto_Open=0
nnoremap <silent> <F8> :TlistToggle<CR>

"nerdtree settings
nnoremap <silent> <F7> :NERDTreeToggle<CR>

"settings for syntastic
let g:syntastic_python_checkers = ['pep8', 'pyflakes', 'python']
"let g:syntastic_cpp_checkers = []
let g:syntastic_aggregate_errors = 1
"don't check automatically
let g:syntastic_mode_map = {
        \ "mode": "passive",
        \ "active_filetypes": [],
        \ "passive_filetypes": [] }

"vim airline
let g:airline#extensions#tabline#enabled = 1

"ctrlp
let g:ctrlp_custom_ignore = {
        \ 'dir': '\v[\/]\.(git|hg|svn)$',
        \ 'file': '\v\.(ipynb|pyc)$'
\}

autocmd BufNewFile,BufRead *.py call SetPythonOptions()

function SetPythonOptions()
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab
    set autoindent
    set fileformat=unix
endfunction

autocmd BufNewFile,BufRead *.cpp,*.c,*.hpp,*.h call SetCPPOptions()
function SetCPPOptions()
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set noexpandtab
    set autoindent
    set smartindent
endfunction

autocmd BufNewFile,BufRead *.js,*.html,*.css call SetWebOptions()
function SetWebOptions()
    set tabstop=2
    set softtabstop=2
    set shiftwidth=2
endfunction

augroup filetype_all
"autocmd! clears the group out preventing vim from creating the same autocmd multiple times
autocmd!
autocmd FileType python :iabbrev <buffer> iff if:<left>
augroup END

"Shift tab now does reverse tab
inoremap <S-Tab> <C-d>
"p is now a movement for an operator that says everything inside parens so dp will delete everything between parens
"works with all operators such as y (yank), c (change), etc
onoremap p i(
onoremap a i'
onoremap q i"
onoremap b i[
onoremap s i{
onoremap c i<

"outer paren, outer apostrophe, etc"
onoremap op a(
onoremap oa a'
onoremap oq a"
onoremap ob a[
onoremap os a{
onoremap oc a<
"vnoremap FF <Esc>
"as a test..could get annoying
inoremap jk <Esc>
vnoremap jk <Esc>
"force me to get used to this mapping!!!
vnoremap <Esc> <nop>
inoremap <Esc> <nop>

set nowrap

"sets < or > to shift to a multiple of shiftwidth
set shiftround
set cursorline

set hlsearch

set number

set laststatus=2

"need to escape spaces as set allows setting multiple options at once
set statusline=%F "full filename
set statusline+=%m "modified flag
set statusline+=\ - "separator
set statusline+=\ FileType: "label
set statusline+=%y "file type
set statusline+=%= "move everything else to the right
set statusline+=%l "current line
set statusline+=, "separator
set statusline+=%c "current column
set statusline+=/ "separator
set statusline+=%L "total lines
set tags=./tags;/

set ignorecase

set smartcase

set incsearch

set encoding=utf-8

let g:netrw_liststyle=3

"wrap current word in quotes and move to end of word
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
"wrap current word in ' and move to end of word
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
"edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
"source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
"make current word upper case
inoremap <c-u> <esc>viwU<esc>ea
"move line down
nnoremap - ddp
"move line up
nnoremap + ddkkp
nnoremap <leader>k :Explore<CR>

noremap N Nzz
noremap n nzz

nnoremap mm :bn<CR>

nnoremap <silent> <leader><leader> :noh<cr><esc>


nnoremap <leader>g :vimgrep<space>/

nnoremap % v%

nnoremap <silent> <leader>t :tabnew<CR>
nnoremap <silent> <leader>tq :tabclose<CR>
nnoremap <silent> <leader>tQ :tabonly<CR>
nnoremap <silent> L :tabnext<CR>
nnoremap <silent> H :tabprevious<CR>


nnoremap <leader>wv <C-w>v<CR>
nnoremap <leader>wh <C-w>s<CR>
nnoremap <leader>w <C-w>w<CR>
nnoremap <leader>wq <C-w>q<CR>

"nnoremap <silent> <C-h> :wincmd h<CR>
"nnoremap <silent> <C-j> :wincmd j<CR>
"nnoremap <silent> <C-k> :wincmd k<CR>
"nnoremap <silent> <C-l> :wincmd l<CR>

nnoremap <silent> <C-j> <C-w>w

nnoremap <leader>r <C-R>

nnoremap K <C-b>
nnoremap J <C-f>
nnoremap <leader>i <C-]>
nnoremap <leader>o <C-t>

if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= (i== t ? '%#TabNumSel#' : '%#TabNum#')
            let s .= i
            if tabpagewinnr(i,'$') > 1
                let s .= '.'
                let s .= (i== t ? '%#TabWinNumSel#' : '%#TabWinNum#')
                let s .= (tabpagewinnr(i,'$') > 1 ? wn : '')
            end

            let s .= ' %*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= file
            let s .= (i == t ? '%m' : '')
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
endif

function! BufSel(pattern)
    let bufcount = bufnr("%")
    let currbufnr = 1
    let nummatches = 0
    let firstmatchingbufnr = 0
    while currbufnr <= bufcount
        if(bufexists(currbufnr))
            let currbufname = bufname(currbufnr)
            if(match(currbufname, a:pattern) > -1)
                echo currbufnr . ": ". bufname(currbufnr)
                let nummatches += 1
                let firstmatchingbufnr = currbufnr
            endif
        endif
        let currbufnr = currbufnr + 1
    endwhile
    if(nummatches == 1)
        execute ":buffer ". firstmatchingbufnr
    elseif(nummatches > 1)
        let desiredbufnr = input("Enter buffer number: ")
        if(strlen(desiredbufnr) != 0)
            execute ":buffer ". desiredbufnr
        endif
    else
        echo "No matching buffers"
    endif
endfunction

command! -nargs=1 Bs :call BufSel("<args>")
