set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'kien/ctrlp.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/emmet-vim'
Plugin 'wavded/vim-stylus'
Plugin 'pangloss/vim-javascript'
Plugin 'marijnh/tern_for_vim'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
"Plugin 'mileszs/ack.vim'
Plugin 'rking/ag.vim'
Plugin 'wesQ3/vim-windowswap'

syntax on 
set syn=auto 
set showmatch 
filetype on 
filetype plugin on 
filetype indent on 
set tabstop=4 
set softtabstop=4 
set shiftwidth=4 
set expandtab
set shiftwidth=4
set number
set wildignore+=node_modules

set backupdir=~/.vim/backup
set directory=~/.vim/tmp

syntax enable
set regexpengine=1

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

autocmd FileType javascript noremap <buffer>  <c-d> :call JsBeautify()<cr>

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
