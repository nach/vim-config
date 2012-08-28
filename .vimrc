"
" VIM configuration file of Frederic Chanal
"

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" User option configuration
" =========================

" Tab settings
set expandtab           " Expand tab in space 
set tabstop=4           " Tab length
set softtabstop=4       " Soft tab are 4 space long
set shiftwidth=4        " Indenting length

set backspace=2         " Enable backspace in insert mode
set laststatus=2        " Always display the status line
set hlsearch            " Highlight search
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set ignorecase          " Do case insensitive matching
set smartcase           " Do smart case matching
set incsearch           " Incremental search
set autowrite           " Automatically save before commands like :next and :make
set hidden              " Hide buffers when they are abandoned
set mouse=a             " Enable mouse usage (all modes) in terminals
set ruler               " Display the column and line in the status line
set history=200         " History remember 200 command
set foldmethod=marker   " Use marker for folding
set spellsuggest+=10    " Max number of suggestions
set errorbells          " warn when error with message occurs
set visualbell          " use a visual warning instead of bell
set encoding=utf-8      " Use UTF-8 encoding
set tags=./tags;tags    " Search in current file dir, then in the current working dir

" Add all plugin to runtime path with pathogen
call pathogen#infect()
call pathogen#helptags()

" Enable syntax
syntax on

" Specific C syntax option
set cinoptions+=:0,(0   " left justified 'case', aligned arguements on LF

" Set graphic option
set background=dark

" Graphic enhancement (must be after set 'bg') 
colorscheme wombat

" My mappings
" ===========
noremap <silent> <C-H> :nohl<CR>
map <F4> :NERDTreeFind<CR>
map <silent><F5> :call MyTagUpdate()<CR>
"map <silent> <F5> :!cscope -R -b && ctags -R * &<CR>
nnoremap <silent> <F8> :TlistToggle<CR>
nnoremap <silent> <F9> :NERDTreeToggle<CR>
nnoremap <silent> <F10> :let @*=expand("%:t").":".line(".")<CR>
nnoremap <F11> :GundoToggle<CR>
nnoremap <F12> :split ~/Dropbox/documents/ressources/memo/Soft_FAQ.txt<CR>
vnoremap <silent> // :s/\(\s*\)\(.*\)/\1\/\/\2/ \| nohl<CR>

" Ack
nnoremap <leader>g :Ack --match <C-R>=expand("<cword>")<CR>
            \ <C-R>=expand("%:p:h")<CR>
nnoremap <leader>G :Ack --all --match <C-R>=expand("<cword>")<CR>
            \ <C-R>=expand("%:p:h")<CR>
nnoremap <leader>k :call SearchCaller()<CR>
inoremap <leader>d <C-R>=strftime("%F")<CR>

" CtrlP
noremap <C-P><C-F> :CtrlPMRUFiles<CR>   " look for MRU file
noremap <C-P><C-B> :CtrlPBuffer<CR> " look for current buffers
noremap <C-P><C-R> :CtrlPCurWD<CR>  " find file from the current working dir

" Bufexplorer
noremap <silent> ² :BufExplorer<CR>

" Change the '^]' so that it display multiple choice when necessary
" nnoremap <C-]> :if len(taglist(expand("<cword>"))) <= 1 \| 
"     \ execute("tag ".expand("<cword>")) \| :else \|
"     \ execute("tselect ".expand("<cword>")) \| :endif<CR>
nmap <silent> <C-]> :tjump <C-R><C-W><CR>
nmap <silent> <C-W>] :stjump <C-R><C-W><CR>
nmap <silent> <C-W>} :ptjump <C-R><C-W><CR>

" Plugin modifier
" ===============
let VCSCommandMapPrefix="<leader>v" " Mapping modifier for VCSCommand plugin
"set statusline=%<%f\ %([%{Tlist_Get_Tagname_By_Line()}]%)%h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
let NERDTreeHijackNetrw=0
let Tlist_Use_Right_Window=1

" CtrlP
let g:ctrlp_map="<C-P><C-P>"
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.swp$\|\.swo$\|\.pyc$\|\/\..*\|tags\|cscope.*\|\.rej$\|\.o\|\.d',
            \ 'link': '',
            \ }
let g:ctrlp_working_path_mode=2 " root dir search

" Pep8 / python validation tool
let g:pep8_map="<leader>p"

" Alternate file
let g:alternateNoDefaultAlternate = 1
let g:alternateRelativeFiles = 1

" tag list
nmap <silent> !  :if bufwinnr(g:TagList_title) != -1 \| TlistHighlightTag \| :endif \| TlistShowPrototype<CR>

" User defined functions
" ======================
function! SearchCaller()
    if has("cscope")
        if !cscope_connection(0) && getftype("cscope.out") == 'file'
            cscope add cscope.out
        endif
        cscope f c <cword>
    else
       echoerr "cscope not available on this platform" 
    endif
endfunction

function! MyTagUpdate()
    let l:rootdir = finddir(".git", ".;") 
    let l:rootdir = fnamemodify(l:rootdir, ":s/\.git//")
    execute "silent !ctags -R --tag-relative --languages=\"C,C++,Python,Make\" -f ".l:rootdir."tags "  
                \ .l:rootdir." &"

    " let l:tagfilename = 'tag.list'
    " if getftype(tagfilename) == 'file'
    "     call delete('tags')
    "     let l:cscopelist = []
    "     for line in readfile(tagfilename)
    "         if (match(line, '^#') == -1) && (match(line, '^\s*$') == -1)
    "             let l:cscopelist += split(glob("`find ".line." -name *.c -o -name *.h`")) 
    "             execute "!ctags -R -a" line
    "         endif
    "     endfor
    "     call writefile(l:cscopelist, 'cscope.files', 'b')
    "     !cscope -b
    " else
    "     !ctags -R
    "     !cscope -b
    " endif
endfunction

function! SaveAndQuit()
	if (getftype('Session.vim') == "file")
		if (g:loaded_nerd_tree)
			NERDTreeClose
		end
		mksession!
	endif
endfunction

function! CvsStat(dir)
	15new
	set buftype=nofile 
	set bufhidden=wipe
	set noswapfile
	set nobuflisted
	execute "0r!cvs -q -n up ".a:dir." | grep -e '^[^?]'"
endfunction

" User command
" ============
command! -nargs=1 -complete=file Cvsstat call CvsStat(<f-args>)

" Autocommands
" ============
autocmd VimLeave * call SaveAndQuit()
autocmd SessionLoadPost * 
            \ if (getftype("cscope.out") == "file") |
            \   execute "cs add cscope.out" |
            \ endif

" Command
" =======
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

" Other modifications
" ===================
" change grepprg so that it ignore tags and cscope files
set grepprg=grep\ -n\ --exclude=\"*tags\"\ --exclude=\"*cscope*\"\ $*\ /dev/null

" Load specific plugin
" ====================
runtime! ftplugin/man.vim

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on


  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Load local tunning settings
" ===========================
if filereadable($HOME."/.vimrc.local")
  source $HOME/.vimrc.local
endif

