" http://vimhelp.appspot.com/usr_05.txt.html#usr_05.txt

function! AppleInterfaceStyle()
	let cmd='if [ `defaults read -g AppleInterfaceStyle 2>/dev/null` ]; then echo "Dark"; else echo "Light"; fi'
	let apple_interface_style=substitute(system(cmd), '[\]\|[[:cntrl:]]', '', 'g')
	if apple_interface_style == "Dark"
    set background=dark
	else
		set background=light
	endif
endfunction

if has("autocmd")
	autocmd BufNewFile,BufRead * call AppleInterfaceStyle()
endif

" Use the Xcode theme
colorscheme xcode

" Enable italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" Disable Vi-compatibility
" equivalent to 'set nocp'
set nocompatible

" Enable backspace in Insert mode
" - white space at the start of the line
" - line break
" - the character before where Insert mode started
" equivalent to 'set bs=2'
set backspace=indent,eol,start

" Enable arrow keys in Insert mode
" equivalent to 'set ek'
set esckeys

" Use the indent of the previous line for a newly created line
" equivalent to 'set ai'
set autoindent

" Show the (partial) command as it’s being typed
" equivalent to 'set sc'
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