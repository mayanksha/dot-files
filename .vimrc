"*************************************************************************
" 
" GIT REPO = mayanksha/vimrc (github)
"
"*************************************************************************
"*************** Custom Mappings ***************



"Map leader Key to ","
	let mapleader=","
"Remapped NUL to switch buffers
	inoremap <S-Tab> <C-V><Tab>
"Mappings for calling NERDComment using c
	nnoremap c :call NERDComment('n', 'SexyToggle')<CR>
	vnoremap c :call NERDComment('x', 'SexyToggle')<CR>
	nnoremap C :call NERDComment('n', 'NormalToggle')<CR>
	vnoremap C :call NERDComment('x', 'NormalToggle')<CR>
"nmap <Leader> <leader>c<space>
	noremap <Nul> :bn<CR>
	nnoremap <C-B> :bp<CR>
	nnoremap <F2> :bd<CR>
	nnoremap <C-e> :call CloseBufWithoutClosingNetrw()<CR>
" Use ctrl-[hjkl] to select the active split!
	nmap <silent> <c-k> :wincmd k<CR>
"nmap <silent> <c-j> :wincmd j<CR>
	nmap <silent> <c-h> :wincmd h<CR>
	nmap <silent> <c-l> :wincmd l<CR>
"Code Folding in VIM
	inoremap <F3> <C-O>za
	nnoremap <F3> za
	onoremap <F3> <C-C>za
	vnoremap <F3> zf
	vnoremap <F6> zM

	map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
	map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"Remap + and 0 for going to first non-whitespace character
	nnoremap ^ 0
	nnoremap 0 ^

"Save with sudo
	"command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
"Map move to end of word to w
	map w e
"Vim Surround mappings
	vnoremap <Plug>VSurround  :<C-U>call <SID>opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
	xnoremap <silent> <M-"> :call <SNR>34_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>"
	xnoremap <silent> [ :call <SNR>34_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>]
	xnoremap <silent> 4 :call <SNR>34_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>$
	xnoremap <silent> ' :call <SNR>34_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>'
	xnoremap <silent> ( :call <SNR>34_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>)
	xnoremap <silent> { :call <SNR>34_opfunc(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>}
"Delete Surrounding Pairs
	nnoremap <C-x> %x``x
	xnoremap <C-x> %x``x

	vnoremap . :normal .<CR>
	vnoremap <C-c> "+y
	vnoremap <C-v> "+p
	nnoremap <C-v> "+p

	nmap <F5> :GoRun<CR>
	nmap <F6> :call ToggleListChars()<CR>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>


"*************** vim-plug Installation if not already installed  ***************

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


"*************** vim-plug Configuration  ***************
"
	set nocompatible	"Changes other options as side effect filetype off                  " required

    call plug#begin('~/.vim/plugged')

    " General
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'jiangmiao/auto-pairs'
	Plug 'ervandew/supertab'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-surround'
	Plug 'alvan/vim-closetag'
	Plug 'terryma/vim-multiple-cursors'
	Plug 'Valloric/YouCompleteMe'
	Plug 'mayanksha/nerdcommenter'
	Plug 'vim-utils/vim-man'
	Plug 'w0rp/ale'
    Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}
	Plug 'davidhalter/jedi-vim'
	Plug 'jparise/vim-graphql'

    " Golang
	Plug 'fatih/vim-go'
	Plug 'stamblerre/gocode', {'rtp': 'vim/'}

    " Javascript
	" Plug 'Quramy/vim-js-pretty-template'
	" Plug 'leafgarland/typescript-vim'
	" Plug 'ternjs/tern_for_vim'
	" Plug 'pangloss/vim-javascript'
	" Plug 'mxw/vim-jsx'
	" Plug 'mattn/emmet-vim'

	call plug#end()

"*************** Set commands ***************
"
	packadd! matchit
	syntax enable
	"set relativenumber
	let g:neodark#background = '#232227'
	colorscheme neodark
	set t_Co=256
	set tabstop=4
	set shiftwidth=4	"Number of spaces to use for autoindenting
	set autoindent	    "Autoindenting always on
	set expandtab	    "Expands a <Tab> to 'tabstop' number of spaces
	set copyindent	    "Copy Previous indent on autoindenting
	set number
	set showmatch	    "Show matching parenthesis
	set smarttab	    "insert tabs on the start of a line according to shiftwidth, not tabstop
	set hlsearch	    "highligh search terms
	set incsearch	    "show search matches as you type
	set backspace=indent,eol,start
	set undolevels=1000
	set history=1000	"History amount
	set laststatus=2	"Always Display the status line
	set ttimeoutlen=0
	set timeoutlen=5	"Set the timeout for change from insert to normal mode
	"change in vim airline
	set encoding=utf-8
	"set cursorcolumn
	"set cursorline
	set hidden
	set splitbelow
	set nofoldenable    "Open all the folds at the time of opening a file
	set foldmethod=indent
	set foldnestmax=3
	set wildmenu
	set mouse=a     "Enable scrolling with mouse - useful for X sessions only
	set shortmess+=c
	set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.o,*.a     " MacOSX/Linux
	set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
	set secure      "Disallows execution of autocmd and write commands in Project specific .vimrc
	set exrc        "Project specific .vimrc files
	set listchars=tab:▸.
	set diffopt+=iwhite
	set tags=./tags;

    " Use interactive shell (see: https://github.com/instant-markdown/vim-instant-markdown#faq)
    set shell=bash\ -i

    " set noendofline binary     "Helps to remove the trailing newline character added by vim

    " Save your backup files to a less annoying place than the current directory.
    " If you have .vim-backup in the current directory, it'll use that.
    " Otherwise it saves it to ~/.vim/backup or .
    if isdirectory($HOME . '/.vim/backup') == 0
      :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
    endif

    set backupdir-=.
    set backupdir+=.
    set backupdir-=~/
    set backupdir^=~/.vim/backup/
    set backupdir^=./.vim-backup/
    set backup

    " Save your swap files to a less annoying place than the current directory.
    " If you have .vim-swap in the current directory, it'll use that.
    " Otherwise it saves it to ~/.vim/swap, ~/tmp or .
    if isdirectory($HOME . '/.vim/swap') == 0
      :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
    endif

    set directory=./.vim-swap//
    set directory+=~/.vim/swap//
    set directory+=~/tmp//
    set directory+=.

    " viminfo stores the the state of your previous editing session
    set viminfo+=n~/.vim/viminfo

    if exists("+undofile")
      " undofile - This allows you to use undos after exiting and restarting
      " This, like swap and backup files, uses .vim-undo first, then ~/.vim/undo
      " :help undo-persistence
      " This is only present in 7.3+
      if isdirectory($HOME . '/.vim/undo') == 0
        :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
      endif
      set undodir=./.vim-undo//
      set undodir+=~/.vim/undo//
      set undofile
    endif

	"setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1 "https://gcc.gnu.org/wiki/FormattingCodeForGCC


"*************** Custom Mappings ***************
"

filetype plugin indent on	"Turns the filetype plugin on
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags	"Autocompletes HTML tags
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript,typescript,html,json setlocal shiftwidth=2 tabstop=2
autocmd FileType graphql setlocal shiftwidth=4 tabstop=4

autocmd FileType go set foldmethod=syntax
autocmd FileType java setlocal omnifunc=javacomplete#Complete

autocmd FileType c,cpp set keywordprg=cppman
" autocmd FileType c,cpp nmap <F4> :YcmCompleter FixIt<CR>
autocmd FileType javascript.jsx ALEDisable 
autocmd FileType javascript,typescript nmap <F4> :ALEFix <CR>
autocmd FileType typescript nnoremap <C-]> :ALEGoToDefinition <CR>
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd BufReadPost  *.js  nnoremap <buffer> K :TernDoc<CR>
"autocmd FileType typescript syn clear foldBraces 

autocmd FileType tex setlocal
" autocmd FileType python nmap <F5> :w <CR> :!python3 %<CR>
" autocmd FileType sh nmap <F5> :w <CR> :!./%<CR>
" autocmd FileType c nmap <F5> :!clear;gcc -g % -lpthread && ./a.out<CR>
" autocmd FileType cpp nmap <F5> :!clear<CR> :!g++ -g -std=c++11 % && ./a.out<CR>
" autocmd FileType tex nmap <F5> :!latexmk -pdf -pdflatex=xelatex ./cv.pdf<CR>
au BufRead,BufNewFile *.ts  setlocal filetype=typescript


"*************** let commands ***************
" Add an extra space before comments
let NERDSpaceDelims=1

" Ctrl P Settings
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['node_modules/', '.git/']
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|DS_Store|venv)|(\.(swp|ico|git|svn|html))$'

" Go Fmt 
let g:go_fmt_experimental = 1

" Vim-Instant-Markdown 
let g:instant_markdown_open_to_the_world = 0
let g:instant_markdown_autostart = 0

" TernJS Configuration
let g:tern_show_argument_hints = 'never'
let g:tern_show_signature_in_pum = 1
" ale configuration for linting
	
let g:ale_completion_enabled = 1
let g:airline#extensions#ale#enabled = 1
"let g:ale_fix_on_save = 1
let g:ale_linters = {
\   'javascript': ['jshint'],
\		'typescript': ['tsserver'],
\		'latex': [],
\		'python': [],
\		'c': []
\}
let g:ale_fixers = {
\   'typescript': ['tslint'],
\   'javascript': ['eslint'],
\}
let g:ale_linters_explicit = 0
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.js"
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:pymode_python = 'python3'
highlight ALEError ctermbg=Brown ctermfg=White

"JEDI VIM CONFIGURATION 
"Disables the function definitions
"let g:jedi#show_function_definition = 0

"FOR YCM, to query the omni completion engine at each keypress. Might cause
"stuttering
"let g:ycm_cache_omnifunc = 1
"
let g:ycm_gocode_binary_path = "$GOPATH/bin/gocode"
let g:ycm_godef_binary_path = "$GOPATH/bin/godef"
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_min_num_identifier_candidate_chars = 5
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_confirm_extra_conf = 0
let g:ycm_always_populate_location_list = 1
let g:ycm_log_level = "debug"
let g:ycm_semantic_triggers =  {
  \   'c,python' : ['->', '.','re![_a-zA-Z0-9]'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::', 're![_a-zA-Z0-9]'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
let g:ycm_filetype_blacklist = { 'markdown' : 0, 'go' : 0 }
let g:typescript_compiler_binary = 'tsc'

"let g:typescript_compiler_options = ''
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

"Below option shows the method's signature while completion
"let g:tsuquyomi_completion_detail = 1
"let g:tsuquyomi_use_vimproc=1

"autocmd FileType typescript setlocal completeopt+=menu,preview

"Enable vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1
let g:airline_section_y = ''

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

let g:airline_theme='wombat'

let g:SuperTabDefaultCompletionType = "context"

"Vim-Multiple Cursors Configuration
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_cpp = 1
let g:NERDCompactSexyComs = 1
let g:NERDToggleSexyComments = 1

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" Show trailing whitespace and spaces before a tab:
:match ExtraWhitespace /\s\+$\| \+\ze\t/

autocmd FileType netrw setl bufhidden=wipe

" Custom function to toggle listchars (specifically for tab)
function! ToggleListChars()
    if &list
       set nolist
    else
       set list
    endif
endfunction

" Custom function to format (pretty print) a json file
function! FormatJSON()
    :%!python -m json.tool
endfunction

" If running in a WSL terminal, then change Ctrl + C copying
if executable('wslpath')
    autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' |  clip.exe')
endif

