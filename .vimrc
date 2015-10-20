set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/emmet-vim'
Plugin 'wavded/vim-stylus'
"Plugin 'othree/yajs.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'marijnh/tern_for_vim'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-easytags'
Plugin 'rking/ag.vim'
Plugin 'wesQ3/vim-windowswap'
Plugin 'vim-scripts/TaskList.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'digitaltoad/vim-jade'
Plugin 'scrooloose/nerdtree'
Plugin 'Shutnik/jshint2.vim'
Plugin 'mxw/vim-jsx'
"Plugin 'bling/vim-airline'
"Plugin 'powerline/powerline'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'paradigm/vim-multicursor'
Plugin 'mxw/vim-xhp'
Plugin 'sjl/gundo.vim'
Plugin 'ap/vim-css-color'

call vundle#end()            " required
filetype plugin indent on    " required

syntax on 
set syn=auto 
set showmatch 
set tabstop=4 
set softtabstop=4 
set shiftwidth=4 
set expandtab
set shiftwidth=4
set number
set wildignore+=node_modules
set wildignore+=dist

set backupdir=~/.vim/backup
set directory=~/.vim/tmp

syntax enable
"set regexpengine=1

set background=dark
colorscheme solarized

set clipboard=unnamed

" shortcut for for loops i js
ab fori for(var i = 0, ii = ___.length; i < ii; i++){

py import uuid
ab uuuid :=pyeval('str(uuid.uuid4())')

function! UUID()
  pyeval('str(uuid.uuid4())')    
endfunction

map ;U :call UUID()<CR>

" shortcut for commenting
function! Komment()
  if getline(".") =~ '\/\/'
    let hls=@/
    s/^\/\///
    let @/=hls
  else
    let hls=@/
    s/^/\/\//
    let @/=hls
  endif
endfunction
map ,/ :call Komment()<CR>

"map ' <Nop>
map ;l :tabprevious<CR>
map ;' :tabnext<CR>
map ;p :tabnew<CR>

nnoremap <F4> :set invpaste paste?<CR>
set pastetoggle=<F4>
set showmode

" Map :W to :w since i always accidentally press wrong
command W w

map <Leader>dr :python debugger_resize()<cr>
map <Leader>di :python debugger_command('step_into')<cr>
map <Leader>do :python debugger_command('step_over')<cr>
map <Leader>dt :python debugger_command('step_out')<cr>

map <Leader>ds :python debugger_run()<cr>
map <Leader>dq :python debugger_quit()<cr>
map <Leader>dc :python debugger_context()<cr>
map <Leader>dp :python debugger_property()<cr>

map <Leader>dwc :python debugger_watch_input("context_get")<cr>A<cr>
map <Leader>dwp :python debugger_watch_input("property_get", '<cword>')<cr>A<cr>

set tags=tags;

let g:syntastic_javascript_checkers = ['eslint']

autocmd FileType javascript noremap <buffer>  <c-d> :call JsBeautify()<cr>

" Multicursor
nnoremap <Leader>c :<c-u>call MultiCursorPlaceCursor()<cr>
nnoremap <Leader>cm :<c-u>call MultiCursorManual()<cr>
nnoremap <Leader>cx :<c-u>call MultiCursorRemoveCursors()<cr>
xnoremap <Leader>cv :<c-u>call MultiCursorVisual()<cr>
nnoremap <Leader>cr :<c-u>call MultiCursorSearch('')<cr>
nnoremap <Leader>cw :<c-u>call MultiCursorSearch('<c-r><c-w>')<cr>
xnoremap <Leader>ck "*y<Esc>:call MultiCursorSearch('<c-r>=substitute(escape(@*, '\/.*$^~[]'), "\n", '\\n', "g")<cr>')<cr>
let g:multicursor_quit = "{<Leader>cq}"

" XML formatter
function! DoFormatXML() range
    " Save the file type
    let l:origft = &ft

    " Clean the file type
    set ft=

    " Add fake initial tag (so we can process multiple top-level elements)
    exe ":let l:beforeFirstLine=" . a:firstline . "-1"
    if l:beforeFirstLine < 0
        let l:beforeFirstLine=0
    endif
    exe a:lastline . "put ='</PrettyXML>'"
    exe l:beforeFirstLine . "put ='<PrettyXML>'"
    exe ":let l:newLastLine=" . a:lastline . "+2"
    if l:newLastLine > line('$')
        let l:newLastLine=line('$')
    endif

    " Remove XML header
    exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

    " Recalculate last line of the edited code
    let l:newLastLine=search('</PrettyXML>')

    " Execute external formatter
    exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

    " Recalculate first and last lines of the edited code
    let l:newFirstLine=search('<PrettyXML>')
    let l:newLastLine=search('</PrettyXML>')
    
    " Get inner range
    let l:innerFirstLine=l:newFirstLine+1
    let l:innerLastLine=l:newLastLine-1

    " Remove extra unnecessary indentation
    exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

    " Remove fake tag
    exe l:newLastLine . "d"
    exe l:newFirstLine . "d"

    " Put the cursor at the first line of the edited code
    exe ":" . l:newFirstLine

    " Restore the file type
    exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

let mapleader = "\\"

nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>

nmap <leader>e A<Esc>x

filetype plugin indent on

"define 3 custom highlight groups
hi User1 ctermbg=green ctermfg=red   guibg=green guifg=red
hi User2 ctermbg=red   ctermfg=blue  guibg=red   guifg=blue
hi User3 ctermbg=blue  ctermfg=green guibg=blue  guifg=green
 
set statusline=
"set statusline+=%1*  "switch to User1 highlight
set statusline+=%F   "full filename
set statusline+=%2*  "switch to User2 highlight
set statusline+=%y   "filetype
set statusline+=%3*  "switch to User3 highlight
set statusline+=%l   "line number
set statusline+=%*   "switch back to statusline highlight
set statusline+=%P   "percentage thru file

set laststatus=2

" Turn of beep
set noeb vb t_vb=

:highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen

" Show trailing whitespace:
:match ExtraWhitespace /\s\+$/

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" No more ex mode
nnoremap Q <nop>

" Remember folds
autocmd BufWrite * mkview
autocmd BufRead * silent loadview

" Ignore folders etc in ctrl p
let g:ctrlp_custom_ignore = {
  \ 'dir':  '(node_modules)'
  \ }

set exrc            " enable per-directory .vimrc files
set secure          " disable unsafe commands in local .vimrc files

set hlsearch

" Sometimes easytags takes to much time when we save a file, so this is
" supposed to make it faster
"let g:easytags_syntax_keyword = 'always'

let g:jsx_ext_required = 0 " Allow JSX in normal JS files
au BufRead,BufNewFile *.jsx set filetype=javascript

let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile 
  autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function LargeFile()

  " no syntax highlighting etc
  set eventignore+=FileType
  " save memory when other file is viewed
  setlocal bufhidden=unload
  " is read-only (write with :w new_filename)
  setlocal buftype=nowrite
  " no undo possible
  setlocal undolevels=-1
  " display message
  autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."

endfunction

set undodir=~/.vim/undo/
set undofile
set undolevels=1000
set undoreload=10000

" Repeat commands
vnoremap . :normal .<CR>

" vim colors settings
let g:cssColorVimDoNotMessMyUpdatetime = 1

set statusline+=%{SyntasticStatuslineFlag()}
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
