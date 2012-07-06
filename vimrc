if !exists("g:loaded_pathogen")
  call pathogen#runtime_append_all_bundles()
  call pathogen#helptags()
endif

" solarized options
set background=dark
colorscheme solarized

set hidden
set ts=2 sts=2 sw=2 expandtab
set hlsearch

" default <leader> key, switched from '\'
let mapleader=','


" Quick open the .vimrc file for edits!
nmap <silent> <leader>rc :e $MYVIMRC<CR>

" Autocompletion
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" Show syntax highlighting groups for word under cursor (C-Shift-P)
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" Set 'par' to handle formating text via gqip
set formatprg=par

" Key Maping.
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
nnoremap <F4> :GundoToggle<CR>

" netrw settings
let g:netrw_liststyle=3
" let g:netrw_browse_split=4
" let g:netrw_preview=1

" Adjust window size using Command+Arrow (+/- 5)
nnoremap <F7> :vertical resize +5<CR>
nnoremap <F8> :vertical resize -5<CR>
nnoremap <S-F8> :resize +5<CR>

" This clears the last highlighted pattern after a searh by hitting return
nnoremap <CR> :noh<CR><CR>

" ,ew expands as :e path/to/directory/of/currentfile
" ew: Open in Window es: split ev: vertical et: tab
" also: allows expand current dir anywhere at cmdline with '%%'
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%


" Mapping to control active window. C-h through C-l
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Removes menu bar / toolbar in gvim
set guioptions-=m
set guioptions-=T

" Set default font and size
set guifont=Menlo:h14

" Setrs search highlighting when hitting  line numbers
set number

" Shortcut to rapidly toggle list, ie. show/hide whitespace
nmap <leader>l :set list!<CR>

" Toggle spell checking on and off with ,s
nmap <leader>s :set spell!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection and syntax highlight
  filetype plugin indent on
  syntax on

  " Source the vimrc file after a save
  autocmd! bufwritepost .vimrc source $MYVIMRC
  autocmd! bufwritepost vimrc source $MYVIMRC

  " Restore cursor posistion when reediting file.
  autocmd BufReadPost *
  	\ if line("'\"") > 1 && line("'\"") <= line("$") |
    	\   exe "normal! g`\"" |
    	\ endif
  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab

  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml
endif

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" Function to strip the trailing whitespace from end of lines.
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
