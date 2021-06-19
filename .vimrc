" http://vimhelp.appspot.com/usr_05.txt.html#usr_05.txt

" Enable italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" Disable Vi-compatibility
set nocompatible

" Enable backspace in Insert mode
" - white space at the start of the line
" - line break
" - the character before where Insert mode started
set backspace=indent,eol,start

" Enable arrow keys in Insert mode
set esckeys

" Use the indent of the previous line for a newly created line
set autoindent

" Show the (partial) command as it’s being typed
set showcmd

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Enable syntax highlighting
syntax on

" Enable mouse in all modes
set mouse=a

" Use system clipboard
" even works in Vim compiled without '+clipboard'
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>
