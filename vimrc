set fenc=utf8
set fencs=utf8,usc-born,euc-jp,gb18030,gbk,gb2312,cp936,big5
set enc=utf8
set termencoding=encoding
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
set nu
set gfn=Monospace\ 10
set shell=/bin/bash
set autoindent
set smartindent
set cindent
set tabstop=4
set shiftwidth=4
set tags=/usr/include/tags


if &t_Co > 1
   syntax enable
endif


"set is
set hls	

if has("gui_running")
	set guioptions-=T
	set t_Co=256
	set background=dark
	colorscheme darkblue 

else
	"colorscheme darkblue
	colorscheme zellner
	set background=dark

endif


" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

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
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

map <F4> :call TitleDet()<cr>
function AddTitle()
    call append(0,"/*******************************************")
    call append(1," *")
    call append(2," * Author: Hongzhou Chen - hongzhoc@amazon.com")
    call append(3," *")
    call append(4," *")
    call append(5," * Last modified:\t".strftime("%m-%d-%Y %H:%M"))
    call append(6," *")
    call append(7," * Filename:\t\t".expand("%:t"))
    call append(8," *")
    call append(9," * Description: ")
    call append(10," *")
    call append(11," *")
    call append(12," *")
    call append(13," *")
    call append(14," *")
    call append(15," *")
    call append(16," ******************************************/")
    echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endf
"update last modified time and file name
function UpdateTitle()
    normal m'
    execute ' /* Last modified:/s@:.*$@\=strftime(":\t%m-%d-%Y %H:%M")@'
    normal ''
    normal mk
    execute ' /* Filename:/s@:.*$@\=":\t\t".expand("%:t")@'
    execute "noh"
    normal 'k
    echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction
"check the first 10 lines to make sure is there a copyright information here 
"or not. If exists, just update the modified time.
function TitleDet()
    let n=1
    "by default, add completed information
    while n < 10
        let line = getline(n)
        if line =~ '^ \* Last\smodified:\t*.*$'
            call UpdateTitle()
            return
        endif
        let n = n + 1
    endwhile
    call AddTitle()
endfunction

set backupdir=./.backup,.,/tmp
set directory=.,./.backup,/tmp

execute pathogen#infect()

"open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"close vim if the only window left open is a NERDTree

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"open NERDTree always on the right
let g:NERDTreeWinPos = "right"

"open NERDTree and Tlist when VIM starts
au VIMEnter *.h  Tlist
au VIMEnter *.c  Tlist
"Open NERDTree later so on the next command we can focus to the main window
au VimEnter *  NERDTree

"focus back main window
autocmd VimEnter * wincmd p
