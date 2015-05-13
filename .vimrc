set nocompatible              " be iMproved, required
set noswapfile
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Bundle 'gmarik/Vundle.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'docunext/closetag.vim'
Bundle 'wincent/command-t'
Bundle 'kchmck/vim-coffee-script'
Bundle 'skammer/vim-css-color'
Bundle 'rstacruz/sparkup'
Bundle 'mitsuhiko/vim-jinja'
Bundle 'pangloss/vim-javascript'
"Bundle 'klen/python-mode'
Bundle 'nvie/vim-flake8'
Bundle 'ervandew/supertab'
Bundle 'scrooloose/syntastic'
Bundle 'jmcantrell/vim-virtualenv'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Great colorscheme
:color molokai

filetype indent plugin on    " required
set mouse=a
set relativenumber
syntax on
set wrap
set textwidth=79
set ignorecase
set smartcase
set wildmenu
set showcmd
set confirm
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
au BufRead *.jinja2 set filetype=html|set syntax=htmljinja|set shiftwidth=2| set softtabstop=2| set tabstop=2
au BufRead *.html set filetype=html|set syntax=htmljinja|set shiftwidth=2| set softtabstop=2| set tabstop=2
au BufRead *.py set colorcolumn=

:nmap sv :w<CR>:source ~/.vimrc<CR>
:nmap vim :tabnew ~/.vimrc<CR>
:nmap vimp :tabnew ~/.vimperatorrc<CR>
:nmap tg :tabclose<CR>
:nmap la '.
:nmap <C-t> :tabnew<CR>
:nmap copy ggvG<END>y
:nmap cut ggvG<END>x
:nmap pdb oimport pdb;pdb.set_trace()<ESC>
:nmap wdb oimport wdb;wdb.set_trace()<ESC>
:nmap tn :tabnew<CR>:set filetype=
:nmap vn :new<CR><C-w>L
:nmap psql :ConqueTermTab psql -U postgres -d hydra<CR>
:nmap py :ConqueTermTab python<CR>
:nmap <S-PageUp> :tabm -1<CR>
:nmap <S-PageDown> :tabm +1<CR>
:nmap doc o"""."""<left><left><left><left>
:vmap com ]#
:vmap ucom ]u
:nmap tpl :set filetype=htmljinja<CR>
:nmap qav :q<CR>:vsp<CR>

" Return to last file
:nmap <C-l> :e#<CR>


fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType * autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
autocmd FileType python autocmd BufWritePre <buffer> :call Flake8()

function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    let markedBuf = bufnr( "%" )
    exe 'hide buf' curBuf
    exe curNum . "wincmd w"
    exe 'hide buf' markedBuf
endfunction

function! Open(path)
  let cdir = getcwd()
  exe "cd " . a:path
  let all_files = split(globpath('.', '*'), '\n')
  let first_file = all_files[0]
  let last_file = all_files[-1]
  let strip_files = all_files[1:-2]
  exe "tabnew " . first_file
  let ctr = 0
  for current_file in strip_files
    if ctr % 2 == 0
      exe "vsp " . current_file
      exe "normal \<C-w>\<Right>"
    else
      exe "sp " . current_file
      exe "normal \<C-w>\<Left>"
    endif
    let ctr = ctr + 1
  endfor
  exe "sp " . last_file
  exe "normal \<C-w>="
  exe "cd ~/Projets/hydra"
endfunction

" Simple re-format for minified Javascript
command! UnMinify call UnMinify()
function! UnMinify()
    %s/{\ze[^\r\n]/{\r/g
    %s/){/) {/g
    %s/};\?\ze[^\r\n]/\0\r/g
    %s/;\ze[^\r\n]/;\r/g
    %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
    normal ggVG=
endfunction

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>

" Frontend mapping
:nmap fe :e ~/Projets/hydra/hydra/star/apps/frontend/
:nmap fs :sp ~/Projets/hydra/hydra/star/apps/frontend/
:nmap fv :vsp ~/Projets/hydra/hydra/star/apps/frontend/
:nmap ft :tabnew ~/Projets/hydra/hydra/star/apps/frontend/

" Admin routes mapping
:nmap rae :e ~/Projets/hydra/hydra/admin/routes/
:nmap ras :sp ~/Projets/hydra/hydra/admin/routes/
:nmap rav :vsp ~/Projets/hydra/hydra/admin/routes/
:nmap rat :tabnew ~/Projets/hydra/hydra/admin/routes/

" Admin templates mapping
:nmap te :e ~/Projets/hydra/hydra/admin/templates/
:nmap ts :sp ~/Projets/hydra/hydra/admin/templates/
:nmap tv :vsp ~/Projets/hydra/hydra/admin/templates/
:nmap tt :tabnew ~/Projets/hydra/hydra/admin/templates/

" Test frontend mapping
:nmap tfe :e ~/Projets/hydra/hydra/star/test/test_apps/test_frontend/test_
:nmap tfs :sp ~/Projets/hydra/hydra/star/test/test_apps/test_frontend/test_
:nmap tfv :vsp ~/Projets/hydra/hydra/star/test/test_apps/test_frontend/test_
:nmap tft :tabnew ~/Projets/hydra/hydra/star/test/test_apps/test_frontend/test_

" Test admin mapping
:nmap tae :e ~/Projets/hydra/hydra/admin/test/test_
:nmap tas :sp ~/Projets/hydra/hydra/admin/test/test_
:nmap tav :vsp ~/Projets/hydra/hydra/admin/test/test_
:nmap tat :tabnew ~/Projets/hydra/hydra/admin/test/test_

" Model mapping
:nmap me :e ~/Projets/hydra/hydra/model/
:nmap ms :sp ~/Projets/hydra/hydra/model/
:nmap mv :vsp ~/Projets/hydra/hydra/model/
:nmap mt :tabnew ~/Projets/hydra/hydra/model/
