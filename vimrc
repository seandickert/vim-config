let mapleader=" "
source /Users/seandickert/.vim/python_calls.vim

"turn on syntax highlighting
syntax on  

augroup filetype_all
"autocmd! clears the group out preventing vim from creating the same autocmd multiple times
autocmd!
autocmd FileType python :iabbrev <buffer> iff if:<left>
augroup END

"p is now a movement for an operator that says everything inside parens so dp will delete everything between parens
"works with all operators such as y (yank), c (change), etc
onoremap p i(
"inoremap FF <Esc>
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

let g:netrw_liststyle=3

"wrap current word in quotes and move to end of word
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
"edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
"source vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>
"make current word upper case
inoremap <c-u> <esc>viwU<esc>i
"move line down
nnoremap - ddp
"move line up 
nnoremap + ddkkp
nnoremap <leader>k :E<CR>

noremap N Nzz
noremap n nzz

nnoremap <silent> <leader><leader> :noh<cr><esc>

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

nnoremap <leader>g :vimgrep<space>/

nnoremap % v%

nnoremap <silent> <leader>t :tabnew<CR>
nnoremap <silent> <leader>tq :tabclose<CR>
nnoremap <silent> <leader>tQ :tabonly<CR>
nnoremap L $
nnoremap H 0
nnoremap <silent> LL :tabn<CR>
nnoremap <silent> HH :tabp<CR>


nnoremap <leader>wv <C-w>v<CR>
nnoremap <leader>wh <C-w>s<CR>
nnoremap <leader>w <C-w>w<CR>
nnoremap <leader>wq <C-w>q<CR>

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
