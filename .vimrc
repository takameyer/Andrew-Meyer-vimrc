"Auto Commands
" Changes to the directory of the file opened in vim

call pathogen#infect()

" Removes trailing white spaces
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" remap jj to escape in insert mode
inoremap jj <Esc>

nnoremap JJJJ <Nop>

nmap <silent> <Leader>p :NERDTreeToggle<CR>

if &term =~ "xterm"
   let &t_Co=256
   if has("terminfo")
      let &t_Sf="\ESC[3%p1%dm"
      let &t_Sb="\ESC[4%p1%dm"
   else
      let &t_Sf="\ESC[3%dm"
      let &t_Sb="\ESC[4%dm"
   endif
endif

"nnoremap <F2> :set invpaste paste?<CR>
"imap <F2> <C-O>:set invpaste paste?<CR>
"set pastetoggle=<F2>

"Filetype
:set filetype=on
:filetype plugin on
:filetype indent on "Follows language rules for indenting

"Non-standard filetype handling
autocmd BufReadPre SConstruct set filetype=python
autocmd BufReadPre SConscript set filetype=python
autocmd BufReadPre *.sch set filetype=javascript

"Various editing options
:set bs=indent,eol,start
:set textwidth=79
:set autochdir
:set tabstop=3
:set sw=3
:set showcmd
:set nu

"Function for building from the editor
function! Compile( opts )
   let origcurdir=getcwd()
   let curdir=origcurdir

   while curdir != "/"
      if filereadable("SConscript")
         break
      endif
      cd ..
      let curdir=getcwd()
   endwhile

   echo 'Building project...'
   let s:cmd='scons'
   let s:output = system( s:cmd . ' ' . a:opts )
   if strlen(s:output) > 0
      let tmpfilename = tempname()
      exe "redir! > " . tmpfilename
         silent echon s:output
      redir END
      execute "silent! cfile " . tmpfilename
      botright copen
      let s:qfix_buffer = bufnr("$")
      call delete( tmpfilename )
   endif
endfunction

map <F9> :call Compile( '-u' )<CR>
map <F10> :call Compile( '-u debug=1')<CR>
"map <F9> :call Compile(0)<CR>
"map <F10> :call Compile(1)<CR>


"Disable auto-comments on ENT and o/O for '//' comments
inoremap <expr> <enter> getline('.') =~ '^\s*//' ? '<enter><esc>S' : '<enter>'
nnoremap <expr> O getline('.') =~ '^\s*//' ? 'O<esc>S' : 'O'
nnoremap <expr> o getline('.') =~ '^\s*//' ? 'o<esc>S' : 'o'

"Theme and color config
:set background=dark
:colorscheme zenburn
:syntax on

:set nocompatible
:set noexrc

:set cpoptions=aABceFsmq
:set noerrorbells
:set whichwrap=b,s,h,l,<,>,~,[,]
:set softtabstop=3
:set expandtab

"Ab defines
:ab sencorehead //******************************************************************************<CR>// File Name: file<CR>// Copyright: SENCORE, Inc. 2011. All rights reserved.<CR>//******************************************************************************
:ab logline m_Log.debug( "%s::%s(%i)", typeid(this).name(), __FUNCTION__, __LINE__ );

"key maps
":nmap ,t :!(cd %:p:h;ctags *.[ch])&

