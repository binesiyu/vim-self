" basic {
set nocompatible " be iMproved, required

function! OSX()
    return has('macunix')
endfunction
function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction

function! ISHOME()
    if exists('g:isHome')
        return g:isHome
    end
endfunction

" }

" language and encoding setup {

" always use English menu
" NOTE: this must before filetype off, otherwise it won't work
set langmenu=none

" use English for anaything in vim-editor.
if WINDOWS()
    silent exec 'language english'
elseif OSX()
    if !has("gui_vimr")
        " silent exec 'language en_US.UTF-8'
    end
else
    let s:uname = system("uname -s")
    if s:uname == "Darwin\n"
        " in mac-terminal
        silent exec 'language en_US'
    else
        " in linux-terminal
        silent exec 'language en_US.utf8'
    endif
endif

if !has('nvim')
    if OSX()
        set pythondll=''
    endif
endif


" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if WINDOWS()
    " Be nice and check for multi_byte even if the config requires
    " multi_byte support most of the time
    if has('multi_byte')
        " Windows cmd.exe still uses cp850. If Windows ever moved to
        " Powershell as the primary terminal, this would be utf-8
        set termencoding=cp850
        " Let Vim use utf-8 internally, because many scripts require this
        set encoding=utf-8
        setglobal fileencoding=utf-8
        " Windows has traditionally used cp1252, so it's probably wise to
        " fallback into cp1252 instead of eg. iso-8859-15.
        " Newer Windows files might contain utf-8 or utf-16 LE so we might
        " want to try them first.
        set fileencodings=ucs-bom,utf-8,gbk,gb2312,big5,iso-8859-15,utf-16le
    endif
    if !exists('g:exvim_custom_path')
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    else
        let g:ex_tools_path = g:exvim_custom_path.'/vimfiles/tools/'
        let g:ex_dein_path = g:exvim_custom_path.'/vimfiles/dein'
        exec 'set rtp+=' . fnameescape ( g:exvim_custom_path.'/vimfiles/dein/repos/github.com/Shougo/dein.vim/' )
    endif
else
    " set default encoding to utf-8
    set encoding=utf-8
    set termencoding=utf-8

    let g:ex_tools_path = '~/.vim/tools/'
    let g:ex_dein_path = '~/.vim/dein/'
    set rtp+=~/.vim/dein/repos/github.com/Shougo/dein.vim

    if has('multi_byte')
        set fileencodings=ucs-bom,utf-8,gbk,gb2312,big5,iso-8859-15,utf-16le
    endif
endif


scriptencoding utf-8

let mapleader = ','
let maplocalleader=mapleader
" }

" Bundle steup {

filetype off " required


" Plugin Commands
com! -nargs=+  -bar   Plugin call dein#add(<args>)
" PluginInstall
com! -nargs=* -bang  PluginInstall call dein#install()
" PluginUpdate
com! -nargs=* -bang  PluginUpdate call dein#update()
" PluginReCache
com! -nargs=* -bang  PluginReCache call dein#recache_runtimepath()

if !has('nvim')
    " matchit
    source $VIMRUNTIME/macros/matchit.vim
endif

if dein#load_state(g:ex_dein_path)
call dein#begin(g:ex_dein_path)
" call dein#add('Shougo/dein.vim')
Plugin 'Shougo/dein.vim'
Plugin 'Shougo/vimproc'

" doc
Plugin 'yianwillis/vimcdoc'
" ui
Plugin 'mhinz/vim-startify'

" textobj
Plugin 'kana/vim-textobj-user'
"ai/ii
Plugin 'kana/vim-textobj-indent'
"ae/ie
Plugin 'kana/vim-textobj-entire'
"al/il
Plugin 'kana/vim-textobj-line'
"af/if/aF/iF
" Plugin 'kana/vim-textobj-function'
"av/iv
Plugin 'Julian/vim-textobj-variable-segment'
"ac/ic/aC/iC
Plugin 'coderifous/textobj-word-column.vim'
"ab/ib
Plugin 'rhysd/vim-textobj-anyblock'
" Plugin 'binesiyu/vim-textobj-function-syntax'
Plugin 'binesiyu/vim-textobj-lua'

"an(/in(,"a,/i,
Plugin 'wellle/targets.vim'

" operator
Plugin 'kana/vim-operator-user'
Plugin 'kana/vim-operator-replace'
Plugin 'syngan/vim-operator-furround'
Plugin 'thinca/vim-operator-sequence'

Plugin 'tpope/vim-repeat'
Plugin 'tomtom/tcomment_vim'

" leaderf
Plugin 'Yggdroot/LeaderF',{ 'merged' : 0,}
"ctrlsf
Plugin 'dyng/ctrlsf.vim',{'on': 'CtrlSF'}
" nerdtree
Plugin 'scrooloose/nerdtree'


" lint
Plugin 'sbdchd/neoformat'
Plugin 'dense-analysis/ale'

" autocomplete
Plugin 'Shougo/deoplete.nvim'
Plugin 'deoplete-plugins/deoplete-tag'
Plugin 'deoplete-plugins/deoplete-dictionary'
if !has('nvim')
    " vim-easymotion
    Plugin 'binesiyu/vim-easymotion'
    Plugin 'roxma/nvim-yarp'
    Plugin 'roxma/vim-hug-neovim-rpc'
    Plugin 'nathanaelkane/vim-indent-guides'
else
    Plugin 'binesiyu/hop.nvim'
    Plugin 'binesiyu/nvim-treesitter', {'do': ':TSUpdate','merged' : 0}
    Plugin 'andymass/vim-matchup'
    Plugin 'nvim-treesitter/playground'
    Plugin 'nvim-treesitter/nvim-treesitter-textobjects'
    Plugin 'p00f/nvim-ts-rainbow'
    Plugin 'kevinhwang91/nvim-bqf'
    Plugin 'lukas-reineke/indent-blankline.nvim',{ 'rev': 'lua'}
    set colorcolumn=99999
    if ISHOME()
    else
        Plugin 'tbodt/deoplete-tabnine', { 'build': './install.sh' }
    endif
endif
Plugin 'Raimondi/delimitMate'
" snippet
Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'
" Plugin 'Shougo/neco-syntax'
" Plugin 'autozimu/LanguageClient-neovim',{ 'merged' : 0 ,'on_ft': 'haskell' , 'build': './install.sh' }

" colorscheme
Plugin 'morhetz/gruvbox'

Plugin 'skywind3000/asyncrun.vim'
Plugin 'skywind3000/asynctasks.vim'
" git
Plugin 'airblade/vim-gitgutter'
Plugin 'rhysd/git-messenger.vim' ,{ 'on_cmd' : 'GitMessenger','on_map' : '<Plug>(git-messenger',}
" Plugin 'tpope/vim-fugitive'
Plugin 'lambdalisue/gina.vim',{ 'on_cmd' : 'Gina'}

" vim-airline
Plugin 'bling/vim-airline'
" incsearch
Plugin 'binesiyu/CmdlineComplete'

" vim-markdown
" The 'tabular' plugin must come _before_ 'vim-markdown'.
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'iamcco/markdown-preview.vim'

" todo-vim
Plugin 'freitass/todo.txt-vim'
" lua
Plugin 'binesiyu/vim-quick-community'

Plugin 'binesiyu/vim-lua-ftplugin'  " Lua file type plug-in for the Vim text editor

" haskell
Plugin 'neovimhaskell/haskell-vim'
Plugin 'Twinside/vim-haskellFold'
" csharp
Plugin 'OmniSharp/omnisharp-vim'
" tabular: invoke by <leader>= alignment-character
" ---------------------------------------------------
Plugin 'kshenoy/vim-signature'
" undotree: invoke by <Leader>u
Plugin 'mbbill/undotree'
" " ---------------------------------------------------
" Plugin 'Konfekt/FastFold'
Plugin 'Konfekt/FoldText'

Plugin 'binesiyu/vim-winmode'
" Plugin 'dstein64/vim-win'
" Window chooser
Plugin 't9md/vim-choosewin'
Plugin 'andymass/vim-tradewinds'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'
" Plugin 'moll/vim-bbye'
" Plugin 'vim-scripts/BufOnly.vim'

Plugin 'skywind3000/vim-preview'

Plugin 'binesiyu/exvim',{'merged' : 0}
Plugin 'binesiyu/vim-aftercolor'
Plugin 'leafo/moonscript-vim'

" Plugin 'zchee/vim-flatbuffers',{'merged' : 0}

" Plugin 'puremourning/vimspector',{'merged' : 0}

if OSX()
" Plugin 'binesiyu/smartim',{'merged' : 0}
elseif LINUX()
Plugin 'lilydjwg/fcitx.vim'
endif

call dein#end()
call dein#save_state()
endif

filetype plugin indent on " required
syntax on " required
" }

" Default colorscheme setup {
set background=dark
" colorscheme Monokai-binesiyu
colorscheme gruvbox
" colorscheme solarized
" }

" General {

" backup swap {{
"set path=.,/usr/include/*,, " where gf, ^Wf, :find will search
set notimeout
set nobackup " make backup file and leave it around
set noswf "
" set acd "autochchdir
" }}

" history {{
" Redefine the shell redirection operator to receive both the stderr messages and stdout messages
set shellredir=>%s\ 2>&1
set history=50 " keep 50 lines of command line history
set updatetime=1000 " default = 4000
set autoread " auto read same-file change ( better for vc/vim change )
set maxmempattern=1000 " enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)
" }}

" xterm settings {{
behave xterm  " set mouse behavior as xterm
if &term =~ 'xterm'
    set mouse=a
endif
" }}

" Variable settings ( set all ) {{
set matchtime=0 " 0 second to show the matching paren ( much faster )
set nu " show line number
set rnu " show line number
set scrolloff=7 " minimal number of screen lines to keep above and below the cursor
set nowrap " do not wrap text
set cursorline

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
" }}

" Vim UI {{
set wildmenu " turn on wild menu, try typing :h and press <Tab>
" set wildmode=list:longest,full
set showcmd " display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hidden " allow to change buffer without saving
set shortmess=aoOtTI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line
set titlestring=%t\ (%{expand(\"%:p:.:h\")}/)
set completeopt-=preview
" }}

" set window size (if it's GUI) {{
if !has('nvim')
    if has('gui_running')
        " set window's width to 130 columns and height to 40 rows
        if exists('+lines')
            set lines=40                " 40 lines of text instead of 24
        endif
        if exists('+columns')
            set columns=150
        endif

        " disable menu & toolbar
        set guioptions-=T           " Remove the toolbar
        set guioptions-=m           " Remove the menu
        set guioptions-=L           " Remove the
        set guioptions-=b           " Remove the
        set guioptions-=r           " Remove the
        set gcr=a:block-blinkon0    "noblock"

        " set guifont
        if OSX()
            " set guifontwide=YaHei\ Consolas\ Hybrid:h12
            " set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
            set guifont=DejaVuSansMono\ YaHei\ NF:h12
        elseif WINDOWS()
            set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11:cANSI:qDRAFT
        else
            set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
        endif
    endif
endif
" }}

if has('nvim')
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { "javascript" }, -- List of parsers to ignore installing
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = {},  -- list of language that will be disabled
        custom_captures = {
        }
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",

                -- Or you can define your own textobjects like this
                ["iF"] = {
                    python = "(function_definition) @function",
                    cpp = "(function_definition) @function",
                    c = "(function_definition) @function",
                    java = "(method_declaration) @function",
                },
            },
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    matchup = {
        enable = true,              -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    indent = {
        enable = true
    },
    rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
    -- refactor = {
    --     highlight_definitions = { enable = true },
    --     highlight_current_scope = { enable = true },
    --     navigation = {
    --         enable = true,
    --         keymaps = {
    --             goto_definition = "gnd",
    --             list_definitions = "gnD",
    --             list_definitions_toc = "gO",
    --             goto_next_usage = "<a-*>",
    --             goto_previous_usage = "<a-#>",
    --         },
    --     },
    -- },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    },
}

local cmd =_G.vim.cmd
cmd('highlight link TSKeywordFunction Structure')
cmd('highlight link TSMethod Structure')
cmd('highlight link TSFuncMacro Function')
cmd('highlight link TSKeywordOperator Keyword')

local g = _G.vim.g
g.matchup_matchparen_enabled = 0

local o = _G.vim.o
o.foldmethod="expr"
o.foldexpr="nvim_treesitter#foldexpr()"
EOF
endif

" Text edit {{
set showfulltag " show tag with function protype.
set ai " autoindent
set si " smartindent
set backspace=indent,eol,start " allow backspacing over everything in insert mode
" indent options
" see help cinoptions-values for more details
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30
" default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
" set cinkeys=0{,0},0),:,!^F,o,O,e

set cindent shiftwidth=4 " set cindent on to autoinent when editing c/c++ file, with 4 shift width
set tabstop=4 " set tabstop to 4 characters
set expandtab " set expandtab on, the tab will be change to space automaticaly
set ve=block " in visual block mode, cursor can be positioned where there is no actual character

set sessionoptions -=folds

" set Number format to null(default is octal) , when press CTRL-A on number
" like 007, it would not become 010
" }}

" Fold text {{
" set foldmethod=marker foldmarker={,} 
set foldlevel=9999
set diffopt=filler,context:9999
" }}

" Search {{
set showmatch " show matching paren
set incsearch " do incremental searching
set hlsearch " highlight search terms
set ignorecase " set search/replace pattern to ignore case
set smartcase " set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" set this to use id-utils for global search
set grepprg=lid\ -Rgrep\ -s
set grepformat=%f:%l:%m
" }}

" window op {{
set listchars=tab:›\ ,trail:•,extends:↷,precedes:↶,nbsp:. " Highlight problematic whitespace
set noerrorbells visualbell t_vb=
set fillchars=vert:│,fold:·
set nrformats-=octal
set splitbelow
"}}

" clipboard {{
" define the copy/paste judged by clipboard
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamedplus,unnamed
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

if has("termguicolors")
    " fix bug for vim
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum

    " enable true color
    set termguicolors
endif
"}}
" }

" Auto Command {
if has('autocmd')
    augroup ex
        au!
        " when editing a file, always jump to the last known cursor position.
        " don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        au BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
        au BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
        au BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)

        " ------------------------------------------------------------------
        " Desc: file types
        " ------------------------------------------------------------------

        au FileType text setlocal textwidth=80 " for all text files set 'textwidth' to 78 characters.
        au FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.

        " disable auto-comment for c/cpp, lua, javascript, c# and vim-script
        au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
        au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"

        if has("gui_vimr")
            au FocusGained * checktime
        end
    augroup END
endif
" }

" Key Mappings {

" Don't use Ex mode, use Q for formatting
" map Q gq
map Q =

" change ; to :
noremap ; :
vnoremap ; :
" Swap implementations of ` and ' jump to markers
nnoremap ' `
nnoremap ` '

" copy folder path to clipboard, foo/bar/foobar.c => foo/bar/
nnoremap <silent> <leader>y1 :let @*=fnamemodify(bufname('%'),":p:h")<CR>

" copy file name to clipboard, foo/bar/foobar.c => foobar.c
nnoremap <silent> <leader>y2 :let @*=fnamemodify(bufname('%'),":p:t")<CR>

" copy full path to clipboard, foo/bar/foobar.c => foo/bar/foobar.c
nnoremap <silent> <leader>y3 :let @*=fnamemodify(bufname('%'),":p")<CR>

" map Ctrl-Tab to switch window
nnoremap <leader>wk <C-W><Up>
nnoremap <leader>wj <C-W><Down>
nnoremap <leader>wh <C-W><Left>
nnoremap <leader>wl <C-W><Right>
nnoremap <leader>wm <C-W>_

" noremap <C-c> <Esc>

"When pressing <leader>cd switch to the directory of the open buffer
map <Leader>cd :cd %:p:h<CR>:pwd<CR>

map <Leader>p ]p
map <Leader>P ]P

" Select blocks after indenting
xnoremap < <gv
xnoremap > >gv|

" Use tab for indenting in visual mode
xnoremap <Tab> >gv|
xnoremap <S-Tab> <gv
nnoremap > >>_
nnoremap < <<_
" enhance '<' '>' , do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" Improve scroll, credits: https://github.com/Shougo
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
            \ 'zt' : (winline() == &scrolloff + 1) ? 'zb' : 'zz'
noremap <expr> <C-f> max([winheight(0) - 2, 1])
            \ ."\<C-d>".(line('w$') >= line('$') ? "L" : "H")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
            \ ."\<C-u>".(line('w0') <= 1 ? "H" : "L")
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "4\<C-e>")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "4\<C-y>")

nmap <Space> <C-e>
nmap <S-Space> <C-y>

" Visual-mode swapping
vnoremap <C-W> <Esc>`.``gvP``P
" nnoremap <leader>d "_

" map Up & Down to gj & gk, helpful for wrap text edit
noremap <Up> gk
noremap <Down> gj
" Go to home and end using capitalized directions
" noremap J L
" noremap K H
" noremap H ^
" noremap L $
"j/k to jumplist
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
noremap <Leader>fw [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
noremap <Leader>bl :buffers<CR>:let nr = input("Which one: ")<Bar>exe "buffer " . nr<CR>

" Pull word under cursor into LHS of a substitute (for quick search and
" replace)
" Use regex for searches
" nnoremap / /\v
" vnoremap / /\v
" nnoremap ? ?\v
" vnoremap ? ?\v
" 替换函数。参数说明：
" confirm：是否替换前逐一确认
" wholeword：是否整词匹配
" replace：被替换字符串
function! Replace(confirm, wholeword, replace)
    wa
    let flag = ''
    if a:confirm
        let flag .= 'gec'
    else
        let flag .= 'ge'
    endif
    let search = ''
    if a:wholeword
        let search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
    else
        let search .= expand('<cword>')
    endif
    let replace = escape(a:replace, '/\&~')
    execute '%s/' . search . '/' . replace . '/' . flag . '| update'
endfunction
" 不确认、整词
nnoremap <Leader>rw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、非整词
nnoremap <Leader>rc :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>

" nnoremap <leader>r :%s#\<<C-r>=expand("<cword>")<CR>\>#
" Make Y consistent with D
nnoremap Y y$

noremap! <F1> <Esc>
imap <F1> <C-o>:echo<CR>
inoremap <c-c> <c-[>
noremap <F2> :set wrap!<BAR>set wrap?<CR>
" noremap <F4> :set ignorecase!<BAR>set ignorecase?<CR>
noremap <F4> :set relativenumber!<BAR>set relativenumber?<CR>
" F8 or <leader>/:  Set Search pattern highlight on/off
noremap <F11> :set cursorline!<BAR>set nocursorline?<CR>
noremap <F12> :set cursorcolumn!<BAR>set nocursorcolumn?<CR>

function! VisualSelection() range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> <leader>n :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> <leader>h :<C-u>call VisualSelection()<CR>:set hls<CR>
vnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
vnoremap <silent> <leader>N :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
nnoremap <leader>h :let @/='\<\C<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
nmap <leader>n *
nmap <leader>N #
nnoremap <F8> :let @/=""<CR>
nnoremap <leader>/ :let @/=""<CR>

" Navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap w!! %!sudo tee > /dev/null %

" nnoremap v V
" vnoremap v V
" nnoremap V v
" vnoremap V v

" nnoremap <c-]> g<c-]>
" vnoremap <c-]> g<c-]>
" nnoremap g<c-]> <c-]>
" vnoremap g<c-]> <c-]>

" Fast saving
nnoremap <C-s> :<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
cnoremap <C-s> <C-u>w<CR>
if OSX()
    " Move a line of text using ALT+[jk] or Command+[jk] on mac
    nnoremap <silent><M-j> :m .+1<CR>==
    nnoremap <silent><M-k> :m .-2<CR>==
    inoremap <silent><M-j> <Esc>:m .+1<CR>==gi
    inoremap <silent><M-k> <Esc>:m .-2<CR>==gi
    vnoremap <silent><M-j> :m '>+1<CR>gv=gv
    vnoremap <silent><M-k> :m '<-2<CR>gv=gv
else
    nnoremap <silent><D-j> :m .+1<CR>==
    nnoremap <silent><D-k> :m .-2<CR>==
    inoremap <silent><D-j> <Esc>:m .+1<CR>==gi
    inoremap <silent><D-k> <Esc>:m .-2<CR>==gi
    vnoremap <silent><D-j> :m '>+1<CR>gv=gv
    vnoremap <silent><D-k> :m '<-2<CR>gv=gv
endif
" Visually select the text that was last edited/pasted
noremap gV `[v`]

cabbr <expr> %% expand('%:p:h')
"}

" plug-config  {

let g:vim_wildignore
      \ = '*/tmp/*,*.so,*.swp,*.zip,*.class,tags,*.jpg,
      \*.ttf,*.TTF,*.png,*/target/*,*.exvim*/*,
      \.git,.svn,.hg,.DS_Store,*.svg'

fu! Generate_ignore(ignore,tool, ...) abort
    let ignore = []
    if a:tool ==# 'ag'
        for ig in split(a:ignore,',')
            call add(ignore, '--ignore')
            call add(ignore, "'" . ig . "'")
        endfor
    elseif a:tool ==# 'rg'
        if WINDOWS()
            for ig in split(a:ignore,',')
                call add(ignore, '-g')
                if a:0 > 0
                    call add(ignore, "\"" . ig . "\"")
                else
                    call add(ignore, '!' . ig)
                endif
            endfor
        else
            for ig in split(a:ignore,',')
                call add(ignore, '-g')
                if a:0 > 0
                    call add(ignore, "'!" . ig . "'")
                    " call add(ignore, "'" . ig . "'")
                else
                    " call add(ignore, "'!" . ig . "'")
                    call add(ignore, '!' . ig)
                endif
            endfor

        endif
    endif
    return ignore
endf
"}
let g:global_RootMarkers = ['.git', '.root',]

" ui {
let g:startify_custom_header = []
let g:startify_session_dir = $HOME .  '/.data/' . ( has('nvim') ? 'nvim' : 'vim' ) . '/session'
let g:startify_files_number = 6
let g:startify_list_order = [
      \ ['   These are my bookmarks:'],
      \ 'bookmarks',
      \ ['   These are my sessions:'],
      \ 'sessions',
      \ ['   My most recently used files in the current directory:'],
      \ 'dir',
      \ ['   My most recently used files:'],
      \ 'files',
      \ ]
if OSX()
    let g:startify_bookmarks = [{'c' : '~/Documents/dev/kingdom-of-heaven-client/koh.exvim'},
                \ {'k': '~/Documents/dev/kingdom-of-heaven-client/koh-c.exvim'},
                \ {'x': '~/Documents/dev/koh/koh.exvim'},
                \ {'d': '~/Documents/dev-doc/doc.exvim'},
                \ {'n': '~/Documents/dev/note/note.exvim'},
                \ {'t': '~/Documents/dev/todo/todo.exvim'},
                \ {'s': '~/Documents/dev/sultans2/ROS/sultans.exvim'},
                \'~/.vimrc',
                \'~/.zshrc',
                \]
else
    let g:startify_bookmarks = [ '~/.vimrc', '~/.zshrc']
endif

let g:startify_update_oldfiles = 1
" let g:startify_disable_at_vimenter = 1
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
"let g:startify_session_delete_buffers = 0
let g:startify_change_to_dir = 0
" let g:startify_padding_left = 3
"let g:startify_change_to_vcs_root = 0  " vim-rooter has same feature
let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
      \ ]

if !has('nvim')
let g:indent_guides_default_mapping = 0
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['nerdtree','help', 'man', 'startify', 'vimfiler']
else
lua <<EOF
local vim = _G.vim
local g   = vim.g
g.indent_blankline_char = "│"
g.indent_blankline_show_first_indent_level = false
g.indent_blankline_use_treesitter = true
g.indent_blankline_filetype_exclude = {
    "startify",
    "dashboard",
    "dotooagenda",
    "log",
    "fugitive",
    "gitcommit",
    "packer",
    "vimwiki",
    "markdown",
    "json",
    "txt",
    "vista",
    "help",
    "todoist",
    "NvimTree",
    "peekaboo",
    "git",
    "TelescopePrompt",
    "undotree",
    "flutterToolsOutline",
    "" -- for all buffers without a file type
}
g.indent_blankline_buftype_exclude = {"terminal", "nofile"}
g.indent_blankline_show_trailing_blankline_indent = false
g.indent_blankline_show_current_context = false
g.indent_blankline_context_patterns = {
    "class",
    "function",
    "method",
    "block",
    "list_literal",
    "selector",
    "^if",
    "^table",
    "if_statement",
    "while",
    "for"
}
EOF
endif
" }

" textobj {
map <silent>gsa <Plug>(operator-furround-append-input)
map <silent>gss <Plug>(operator-furround-append-input)
map <silent>gsd <Plug>(operator-furround-delete)
map <silent>gsr <Plug>(operator-furround-replace-input)


" delete or replace most inner furround
" if you use vim-textobj-anyblock
nmap <silent>gsdd <Plug>(operator-furround-delete)<Plug>(textobj-anyblock-a)
nmap <silent>gsrr <Plug>(operator-furround-replace-input)<Plug>(textobj-anyblock-a)

map <silent>gr <Plug>(operator-replace)
nmap <expr>grr '<Plug>(operator-replace)iw'
nmap <expr>grb '<Plug>(operator-replace)ib'
nmap <expr> <Leader>gd operator#sequence#map('y', [',ge'])

map <silent>gdd <Plug>(operator-luadump)
nmap <expr>gddd '<Plug>(operator-luadump)iw'
map <silent>gdD <Plug>(operator-luadumpbefore)
nmap <expr>gdDD '<Plug>(operator-luadumpbefore)iw'
map <silent>gdp <Plug>(operator-luaprint)
nmap <expr>gdpp '<Plug>(operator-luaprint)iw'
map <silent>gdP <Plug>(operator-luaprintbefore)
nmap <expr>gdPP '<Plug>(operator-luaprintbefore)iw'
" }
" leaderf {
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 1
let g:Lf_NeedCacheTime = 0
let g:Lf_UseMemoryCache = 1
let g:Lf_FollowLinks = 1
let g:Lf_UseVersionControlTool = 0
let g:Lf_JumpToExistingWindow = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_RootMarkers = g:global_RootMarkers
" popup mode
let g:Lf_WindowPosition = 'popup'

if ISHOME()
    let g:Lf_PopupWidth = 0.8
else
    let g:Lf_PopupWidth = 0.5
endif

let g:Lf_PreviewInPopup = 1
let g:Lf_WorkingDirectoryMode = 'AF'
let g:Lf_GtagsAutoGenerate = 0
let g:Lf_GtagsAutoUpdate = 0
let g:Lf_ShortcutF = '<C-P>'
let g:Lf_ShortcutB = '<C-B>'
let g:Lf_StlColorscheme = 'gruvbox_material'
let g:Lf_PopupColorscheme = 'gruvbox_default'
let g:Lf_DefaultExternalTool = "rg"
" let g:Lf_ExternalCommand = 'rg %s --no-ignore --hidden -L --files -g "" '
"                 \ . join(Generate_ignore(g:vim_wildignore,'rg',1))
let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2"}
let g:Lf_PreviewResult = {
      \ 'File': 0,
      \ 'Buffer': 0,
      \ 'Mru': 0,
      \ 'Tag': 0,
      \ 'BufTag': 0,
      \ 'Function': 0,
      \ 'Line': 0,
      \ 'Colorscheme': 0
      \}

let g:Lf_NormalMap = {
    \ "_":      [["<C-j>", "j"],
    \            ["<C-k>", "k"],
    \            ["<C-n>", "j"],
    \            ["<C-p>", "k"]
    \           ],
    \ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>'],
    \            ["<F6>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']
    \           ],
    \ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>'],
    \            ["<F6>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']
    \           ],
    \ "Mru":    [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
    \ "Tag":    [],
    \ "BufTag": [],
    \ "Function": [],
    \ "Line":   [],
    \ "History":[],
    \ "Help":   [],
    \ "Self":   [],
    \ "Colorscheme": []
    \}

let g:Lf_CommandMap = {
      \ '<C-]>' : ['<C-V>'],
      \ '<C-X>' : ['<C-S>'],
      \ '<C-J>' : ['<C-N>','<C-J>'],
      \ '<C-K>' : ['<C-P>','<C-K>'],
      \ '<C-V>' : ['<C-E>'],
      \ }

let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git','.hg','.exvim*','*/tmp/*'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.ttf',
        \          '*.o','*.so','*.py[co]']
        \}

nnoremap <Leader>fu :LeaderfFunction<Cr>
nnoremap <leader>fb :LeaderfBuffer<CR>
nnoremap <leader>fm :LeaderfMru<CR>
nnoremap <leader>fl :LeaderfMru<CR>
nnoremap <leader>m :LeaderfMru<CR>
nnoremap <Leader>v :LeaderfFunction<Cr>
nnoremap <leader>l :LeaderfBuffer<CR>
nnoremap <leader>d :<C-U><C-R>=printf("Leaderf file --input %s/",fnamemodify(bufname('%'),':h'))<CR><CR>
nnoremap <leader>fd :<C-U><C-R>=printf("Leaderf file --input %s/",fnamemodify(bufname('%'),':h'))<CR><CR>
nnoremap <leader>o :<C-U><C-R>=printf("Leaderf file --input %s",expand('<cword>'))<CR><CR>
nnoremap <leader>ff :<C-U><C-R>=printf("Leaderf file --input %s",expand('<cword>'))<CR><CR>
nnoremap <leader>fr :<C-U><C-R>=printf("Leaderf file --input %s","<C-R>*")<CR><CR>
" }

"asynctask {
let g:asynctasks_extra_config = [
    \ '~/.vim/.tasks',
    \ ]
" }
" set vfile=/Users/yubin/vfile.txt
" set ei=all
" set verbose=22
" set viminfo="NONE"
"ctrlsf {
"---------------------------------------------------------------------
" 设置CtrlSF使用的搜索工具,默认使用ag,如果没有ag,则考虑使用ack
let g:ctrlsf_ackprg = 'rg'
" let g:ctrlsf_debug_mode = 1
" 窗口大小
if OSX()
    let g:ctrlsf_winsize='20%'
else
    let g:ctrlsf_winsize='10'
endif
" 是否在ctrlsf搜索结果打开其他窗口时,关闭搜索结果窗口
let g:ctrlsf_auto_close = 0
let g:ctrlsf_position = 'bottom'
" 大小写敏感
let g:ctrlsf_case_sensitive = 'yes'
" 默认搜索路径, 设置为project则从本文件的工程目录搜索
let g:ctrlsf_default_root = 'project+wf'
let g:ctrlsf_extra_root_markers = g:global_RootMarkers
" 工程目录的顶级文件夹
let g:ctrlsf_ignore_dir = ['.exvim', '.git', '.hg', '.svn', '.bzr', '_darcs']
" make result windows compact
let g:ctrlsf_indent = 2
" width or height
" 显示的上下文函数
let g:ctrlsf_context = '-B 0 -A 0'
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_auto_focus = {
            \ "at" : "done",
            \ "duration_less_than": 2000
            \ }
let g:ctrlsf_extra_backend_args = {
            \ 'rg': '--vimgrep --hidden -L'
            \ }
" 高亮匹配行: o->打开的目标文件;p->预览文件
" let g:ctrlsf_selected_line_hl = 'op'
let g:ctrlsf_mapping = {
            \ "open": { "key": "<CR>", "suffix": "<C-w>p" },
            \ "next": "<C-n>",
            \ "prev": "<C-p>",
            \ "tab": "<C-T>",
            \ "split": "<C-S>",
            \ "vsplit": "<C-V>",
            \ "quit": ["q","<Esc>"],
            \ }
nnoremap <Leader>st :CtrlSFToggle<CR>
nnoremap <Leader>ss :CtrlSF -W <C-R>=expand('<cword>')<CR><CR>
nnoremap <Leader>k :CtrlSF -W <C-R>=expand('<cword>')<CR><CR>
" nnoremap <Leader><Leader> :CtrlSF -W <C-R>=expand('<cword>')<CR><CR>
nnoremap K :CtrlSF -W <C-R>=expand('<cword>')<CR><CR>
nnoremap <Leader>sf :CtrlSF<Space>
nnoremap <Leader>se :CtrlSF -W <C-R>*<CR>
nnoremap <Leader>se :CtrlSF <C-R>*<CR>
nnoremap <Leader>si :CtrlSF -I -W<Space>
nnoremap <Leader>sI :CtrlSF -I<Space>
nnoremap <Leader>sr :CtrlSF -R -W<Space>
nnoremap <Leader>sR :CtrlSF -R<Space>
nnoremap <Leader>sw <Plug>CtrlSFCwordPath
nnoremap <Leader>sW <Plug>CtrlSFCwordExec
nnoremap <Leader>sp <Plug>CtrlSFPwordExec
" }

" nerdtree {
" ---------------------------------------------------

if ISHOME()
    let g:NERDTreeWinSize = 30
else
    let g:NERDTreeWinSize = 50
endif
let g:NERDTreeMouseMode = 1
" let g:NERDTreeMapToggleZoom = '<Space>'
let g:nerdtree_tabs_open_on_gui_startup=0
let g:nerdtree_tabs_open_on_new_tab=0
let g:NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$', '\.meta$']
map <leader>x :NERDTreeToggle<CR>
map <leader>fx :NERDTreeFind<CR>
" }

" vim-markdown {
if OSX()
    let g:mkdp_path_to_chrome="open -a Google\\ Chrome"
endif
let g:vim_markdown_conceal = 0
let g:vim_markdown_frontmatter = 1
let g:mkdp_auto_close=1
autocmd FileType markdown setlocal conceallevel=0
" noremap <F7> <Plug>MarkdownPreview
" noremap <F8> <Plug>StopMarkdownPreview
" }

" preview {
autocmd FileType qf nnoremap <silent><buffer> <p> :PreviewQuickfix<cr>
autocmd FileType qf nnoremap <silent><buffer> <C-p> :PreviewClose<cr>
autocmd FileType qf nnoremap <silent><buffer> <Esc> :cclose<cr>
" }

" lint {
" When writing a buffer.
let g:ale_sign_error = get(g:, 'ale_error_symbol', '✖')
let g:ale_sign_warning = get(g:,'ale_warning_symbol', '➤')
let g:ale_sign_info = get(g:,'ale_info_symbol', '🛈')
let g:ale_echo_msg_format = get(g:, 'ale_echo_msg_format', '%severity%: %linter%: %s')
let g:ale_lint_on_save = get(g:, 'ale_lint_on_save', 1)

highlight link ALEErrorSign GruvboxRedSign
highlight link ALEWarningSign GruvboxYellowSign

let g:ale_linters = {'cs': ['OmniSharp',],
            \ 'lua' : ['luacheck',],
            \ 'haskell' : ['hlint',]
            \}
" if g:spacevim_lint_on_the_fly
"   let g:ale_lint_on_text_changed = 'always'
"   let g:ale_lint_delay = 750
" else
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_lint_on_enter = 0
  let g:ale_lint_on_insert_leave = 0
" endif
let g:ale_lua_luacheck_executable = expand('~/.luarocks/bin/luacheck')


nnoremap <silent> <leader>el :lopen<CR>
nnoremap <silent> <leader>ec :lclose<CR>
nnoremap <silent> <leader>ee :lnext<CR>
nnoremap <silent> <leader>en :lnext<CR>
nnoremap <silent> <leader>ep :lprevious<CR>
nnoremap <silent> <leader>eN :lNext<CR>
" }

" formatter {
" let g:neoformat_verbose = 1
let g:neoformat_lua_luaformatter = {
            \ 'exe': 'luaformatter',
            \ 'args': ['-s 4'],
            \ }

let g:neoformat_enabled_lua = ['luaformatter']
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
" let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
nnoremap <F7> :Neoformat<CR>
" }


" snippet {
" choose a snippet plugin
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/snippets'

function! CleverTab()
    if getline('.')[col('.')-2] ==# '{'&& pumvisible()
      return "\<C-n>"
    endif
    if neosnippet#jumpable()
          \ && getline('.')[col('.')-2] ==# '(' && !pumvisible()
    elseif pumvisible()
      return "\<C-n>"
    else
      return "\<tab>"
    endif
endfunction

imap <expr> <Tab> CleverTab()
smap <expr> <Tab> CleverTab()

function! CleverEnter() abort
    if pumvisible()
        if neosnippet#expandable()
            return "\<plug>(neosnippet_expand)"
        else
            return deoplete#close_popup() . "\<CR>"
        endif
    elseif getline('.')[col('.') - 2]==#'{'&&getline('.')[col('.')-1]==#'}'
        return "\<Enter>\<esc>ko"
    elseif getline('.')[col('.') - 2]==#'('&&getline('.')[col('.')-1]==#')'
        return "\<Enter>\<esc>ko"
    else
        return "\<Enter>"
    endif
endfunction

imap <expr> <CR> CleverEnter()
smap <expr> <CR> CleverEnter()

function! SuperTab_Shift() abort
    return pumvisible() ? "\<C-p>" : "\<Plug>delimitMateS-Tab"
endfunction
imap <silent><expr><S-TAB> SuperTab_Shift()
smap <silent><expr><S-TAB> SuperTab_Shift()
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-j>     <Plug>(neosnippet_expand_or_jump)
smap <C-j>     <Plug>(neosnippet_expand_or_jump)
xmap <C-j>     <Plug>(neosnippet_expand_target)
" }

" autocomplete {
    " deoplete options
    " let g:deoplete#enable_at_startup = 1

    " 启动后删除
    function! DeopleteEnable() abort
        augroup deoplete_init
            autocmd!
        augroup END
        call deoplete#enable()
    endfunction
    let g:deoplete#enable_at_startup = 0
    augroup deoplete_init
        autocmd InsertEnter * call DeopleteEnable()
    augroup END

    " deoplete options
    call deoplete#custom#option({
                \ 'auto_complete_delay' :  20,
                \ 'ignore_case'         :   0,
                \ 'smart_case'          :   1,
                \ 'camel_case'          :   1,
                \ 'refresh_always'      :   0,
                \ 'max_list'            :   20,
                \ 'skip_multibyte'      :   1,
                \ 'min_pattern_length'  :   1,
                \ })
    " Change the source rank
    call deoplete#custom#source('buffer',      'rank',  200)
    call deoplete#custom#source('neosnippet',      'rank',  1200)

    call deoplete#custom#option('ship_chars', ['(', ')', '<', '>'])
    " keywordk patterns
    call deoplete#custom#option('keyword_patterns', {
                \ '_': '[a-zA-Z_]\k*\(?',
                \ 'tex': '\\?[a-zA-Z_]\w*',
                \ 'ruby': '[a-zA-Z_]\w*[!?]?',
                \})
    " converters
    call deoplete#custom#source('_', 'converters', [
                \ 'converter_remove_paren',
                \ 'converter_remove_overlap',
                \ 'converter_truncate_abbr',
                \ 'converter_truncate_menu',
                \ 'converter_auto_delimiter',
                \ ])
    " Omni input_patterns and functions
    call deoplete#custom#source('omni', 'input_patterns', {
                \'xml': '<[^>]*',
                \'md': '<[^>]*',
                \})

    call deoplete#custom#source('omni', 'functions', {
                \'markdown': 'htmlcomplete#CompleteTags',
                \})

    call deoplete#custom#source('LanguageClient',
                \ 'min_pattern_length',
                \ 2)
    " sh
    call deoplete#custom#option('ignore_sources', {'sh': ['around', 'member', 'tag', 'syntax']})

    " lua
    call deoplete#custom#option('ignore_sources', {'lua': ['dictionary', 'file', 'omni']})

    " markdown
    call deoplete#custom#option('ignore_sources', {'markdown': ['tag']})

    " c c++
    call deoplete#custom#source('clang2', 'mark', '')
    call deoplete#custom#option('ignore_sources', {'c': ['omni']})

    " vim
    call deoplete#custom#option('ignore_sources', {'vim': ['tag']})

    " public settings
    call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
    " call deoplete#custom#source('_', 'matchers', ['matcher_head'])

    inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"
    set isfname-==

    " inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    " function! s:my_cr_function() abort
    "     return deoplete#close_popup() . "\<CR>"
    " endfunction
" }

" editor {
if !has('nvim')
" let g:EasyMotion_do_shade = 0
" let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
nmap t <Plug>(easymotion-prefix)
nmap tt <Plug>(easymotion-sn)
nmap tj <Plug>(easymotion-j)
nmap tk <Plug>(easymotion-k)
nmap tl <Plug>(easymotion-lineforward)
nmap th <Plug>(easymotion-linebackward)
nmap t. <Plug>(easymotion-repeat)
vmap t <Plug>(easymotion-prefix)
vmap tt <Plug>(easymotion-sn)
vmap tj <Plug>(easymotion-j)
vmap tk <Plug>(easymotion-k)
vmap tl <Plug>(easymotion-lineforward)
vmap th <Plug>(easymotion-linebackward)
vmap t. <Plug>(easymotion-repeat)

nmap f <Plug>(easymotion-lineforward)
nmap F <Plug>(easymotion-linebackward)
vmap f <Plug>(easymotion-lineforward)
vmap F <Plug>(easymotion-linebackward)
else
lua <<EOF
-- you can configure Hop the way you like here; see :h hop-config
require'hop'.setup {term_seq_bias = 0.5 }

-- place this in one of your configuration file(s)
local map = vim.api.nvim_set_keymap

map('n', 'tw', "<cmd>lua require'hop'.hint_words()<cr>", {})
map('n', 'th', "<cmd>lua require'hop'.hint_words()<cr>", {})
map('n', 'tl', "<cmd>lua require'hop'.hint_words()<cr>", {})
map('n', 'tj', "<cmd>lua require'hop'.hint_lines()<cr>", {})
map('n', 'tk', "<cmd>lua require'hop'.hint_lines()<cr>", {})
map('n', 'tp', "<cmd>lua require'hop'.hint_patterns()<cr>", {})
map('n', 'ts', "<cmd>lua require'hop'.hint_char2()<cr>", {})
map('n', 'f', "<cmd>lua require'hop'.hint_words_line()<cr>", {})
map('n', 'F', "<cmd>lua require'hop'.hint_words_line()<cr>", {})

map('v', 'tw', "<cmd>lua require'hop'.hint_words()<cr>", {})
map('v', 'th', "<cmd>lua require'hop'.hint_words()<cr>", {})
map('v', 'tl', "<cmd>lua require'hop'.hint_words()<cr>", {})
map('v', 'tj', "<cmd>lua require'hop'.hint_lines()<cr>", {})
map('v', 'tk', "<cmd>lua require'hop'.hint_lines()<cr>", {})
map('v', 'tp', "<cmd>lua require'hop'.hint_patterns()<cr>", {})
map('v', 'ts', "<cmd>lua require'hop'.hint_char2()<cr>", {})
map('v', 'f', "<cmd>lua require'hop'.hint_words_line()<cr>", {})
map('v', 'F', "<cmd>lua require'hop'.hint_words_line()<cr>", {})

vim.cmd [[highlight HopNextKey  cterm=bold ctermfg=196 guifg=#ff007c gui=bold blend=0]]
vim.cmd [[highlight HopNextKey1 cterm=bold ctermfg=202 guifg=#00dfff gui=bold blend=0]]
vim.cmd [[highlight HopNextKey2 cterm=bold ctermfg=208 guifg=#2b8db3          blend=0]]
EOF
endif

"signature
let g:SignatureMarkOrder="\m"
" tabular: invoke by <leader>= alignment-character
" ---------------------------------------------------

noremap <Leader>a& :Tabularize /&<CR>
vnoremap <Leader>a& :Tabularize /&<CR>
noremap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
vnoremap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
noremap <Leader>a=> :Tabularize /=><CR>
vnoremap <Leader>a=> :Tabularize /=><CR>
noremap <Leader>a: :Tabularize /:<CR>
vnoremap <Leader>a: :Tabularize /:<CR>
noremap <Leader>a:: :Tabularize /:\zs<CR>
vnoremap <Leader>a:: :Tabularize /:\zs<CR>
noremap <Leader>a, :Tabularize /,<CR>
vnoremap <Leader>a, :Tabularize /,<CR>
noremap <Leader>a,, :Tabularize /,\zs<CR>
vnoremap <Leader>a,, :Tabularize /,\zs<CR>
noremap <Leader>a<Bar> :Tabularize /<Bar><CR>
vnoremap <Leader>a<Bar> :Tabularize /<Bar><CR>
nnoremap <silent> <leader>= :call g:Tabular(1)<CR>
xnoremap <silent> <leader>= :call g:Tabular(0)<CR>
function! g:Tabular(ignore_range) range
    let c = getchar()
    let c = nr2char(c)
    if a:ignore_range == 0
        exec printf('%d,%dTabularize /%s', a:firstline, a:lastline, c)
    else
        exec printf('Tabularize /%s', c)
    endif
endfunction

let g:tcomment_mapleader1=''
let g:tcomment_mapleader2=''
" the default (g<) is a bit awkward to type
let g:tcomment_mapleader_uncomment_anyway=''
let g:tcomment_mapleader_comment_anyway='gC'
let g:tcomment_textobject_inlinecomment=''
map <Leader>cl :TComment<CR>
map <Leader>ci :TComment<CR>
map <Leader>c<Space> :TComment<CR>
" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" " ---------------------------------------------------

" undotree: invoke by <Leader>u
" ---------------------------------------------------

nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout = 4

" vim-color-solarized
" ---------------------------------------------------
let g:gruvbox_italic = get(g:, 'gruvbox_italic', 0)
" }

" lua {
let g:lua_define_completefunc = 0
let g:lua_define_omnifunc = 0
let g:lua_define_completion_mappings = 0
let lua_version = 5
let lua_subversion = 1
" quick indent in lua
nmap <Leader>z m`=aj'`
nnoremap zo zczO
" }

" haskell {
" }
" csharp {
let g:OmniSharp_server_stdio = 1
" let g:OmniSharp_typeLookupInPreview = 1
let g:omnicomplete_fetch_full_documentation = 1
let g:OmniSharp_timeout = 5
let g:OmniSharp_server_use_mono = 1
" let g:OmniSharp_highlight_types = 2
" let g:OmniSharp_selector_ui = 'ctrlp'

autocmd Filetype cs nnoremap <buffer> <leader>ld :OmniSharpGotoDefinition<CR>
autocmd Filetype cs nnoremap <buffer> <leader>li :OmniSharpFindImplementations<CR>
autocmd Filetype cs nnoremap <buffer> <leader>lp :OmniSharpPreviewDefinition<CR>
autocmd Filetype cs nnoremap <buffer> <leader>lu :OmniSharpFindUsages<CR>
autocmd Filetype cs nnoremap <buffer> <leader>lm :OmniSharpFindMembers<CR>
autocmd Filetype cs nnoremap <buffer> <leader>ly :OmniSharpTypeLookup<CR>
autocmd Filetype cs nnoremap <buffer> <leader>la :OmniSharpGetCodeActions<CR>
autocmd Filetype cs nnoremap <buffer> <leader>ls :OmniSharpFindSymbol<CR>
autocmd Filetype cs nnoremap <buffer> <leader>lt :OmniSharpFindType<CR>
autocmd Filetype cs nnoremap <buffer> <leader>lr :OmniSharpRename<CR><C-N>:res +5<CR>

sign define OmniSharpCodeActions text=💡

" let g:OmniSharp_loglevel = 'info'
" let g:OmniSharp_diagnostic_overrides = {
" \ 'CS1644': {'type': 'None'},
" \}

" augroup OSCountCodeActions
" 	autocmd!
" 	autocmd FileType cs set signcolumn=yes
" 	autocmd CursorHold *.cs call OSCountCodeActions()
" augroup END
"
" function! OSCountCodeActions() abort
" 	if bufname('%') ==# '' || OmniSharp#FugitiveCheck() | return | endif
" 	if !OmniSharp#IsServerRunning() | return | endif
" 	let opts = {
" 				\ 'CallbackCount': function('s:CBReturnCount'),
" 				\ 'CallbackCleanup': {-> execute('sign unplace 99')}
" 				\}
" 	call OmniSharp#CountCodeActions(opts)
" endfunction
" }

" lsp {
let g:LanguageClient_serverCommands = {
    \ 'haskell': ['stack' ,"exec", "--", "hie-wrapper"],
    \ }
" let g:LanguageClient_devel = 1 " Use rust debug build

let g:LanguageClient_loggingLevel = 'DEBUG' " Use highest logging level
" let g:LanguageClient_loggingFile = 'nvim.log' " Use highest logging level
" let g:LanguageClient_serverStderr = 'language-server.log' " Use highest logging level

" let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_selectionUI = 'quickfix'
let g:LanguageClient_diagnosticsList = v:null
let g:LanguageClient_diagnosticsSignsMax = 0
let g:LanguageClient_hoverPreview = 'Never'
let g:LanguageClient_hasSnippetSupport = 0

" Automatically start language servers.
let g:LanguageClient_autoStart = 0
let g:LanguageClient_autoStop = 1
nnoremap <leader>rb :LanguageClientStart<CR>
nnoremap <leader>rs :LanguageClientStop<CR>
noremap <leader>rd :call LanguageClient#textDocument_definition()<cr>
noremap <leader>rr :call LanguageClient#textDocument_references()<cr>
noremap <leader>rv :call LanguageClient#textDocument_hover()<cr>
autocmd FileType haskell setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
" }

" git {

let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:gitgutter_max_signs = 10000

" nnoremap <silent> <leader>gs :Gina status<CR>
nnoremap <silent> <leader>gb :Gina blame<CR>
nnoremap <silent> <leader>gV :Gina log <C-R>=expand("%")<CR><CR>
nnoremap <silent> <leader>gv :Gina log<CR>
nmap <leader>gm <Plug>(git-messenger)
" }

" vim-airline {
" ---------------------------------------------------

let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
" let g:airline_theme = 'powerlineish'
let g:airline#extensions#tabline#enabled = 1 " When you open lots of buffers and typing text, it is so slow.
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline_section_b = "%{fnamemodify(bufname('%'),':p:.:h').'/'}"
" let g:airline_section_c = '%t'
let g:airline_section_y = 'B:%{bufnr("%")} W:%{winnr()}'
" let g:airline_section_warning = airline#section#create(['ale'])
let g:airline#extensions#whitespace#checks = ['trailing']
let g:airline_extensions = ['branch', 'gutentags', 'whitespace', 'tabline', 'ale', 'languageclient']
let g:airline_symbols = {'colnr': ' ℅:'}
" }

" util {
nmap <leader>wr <Plug>WinModeStart
let g:win_mode_default ='resize'

" nnoremap <leader>ww :Win<CR>
" invoke with '-'
nnoremap <leader>ww :ChooseWin<CR>
" if you want to use overlay feature
" tmux-like overlay color
let g:choosewin_label = 'ASDFJKLZXGHCV'
let g:choosewin_color_overlay = {
            \ 'gui': ['DodgerBlue3', 'DodgerBlue3'],
            \ 'cterm': [25, 25]
            \ }
let g:choosewin_color_overlay_current = {
            \ 'gui': ['firebrick1', 'firebrick1'],
            \ 'cterm': [124, 124]
            \ }
let g:choosewin_color_label = {
	\ 'cterm': [ 22, 15,'bold' ], 'gui': [ 'DarkGreen', 'white', 'bold' ] }
let g:choosewin_color_label_current = {
	\ 'cterm': [ 40, 16, 'bold' ], 'gui': [ 'LimeGreen', 'black', 'bold' ] }
let g:choosewin_color_other = {
	\ 'cterm': [ 240, 0 ], 'gui': [ 'gray20', 'black' ] }

let g:choosewin_overlay_enable = 0
let g:choosewin_tabline_replace    = 1 " don't replace tabline
let g:choosewin_blink_on_land      = 0 " don't blink at land
let g:choosewin_statusline_replace = 1 " don't replace statusline

" let g:choosewin_hook = {}
" function! g:choosewin_hook.filter_window(winnums)
"   return filter(a:winnums,
"     \ 'index(g:indent_guides_exclude_filetypes,
"     \   getwinvar(v:val, "&filetype")) == -1' )
" endfunction

" }


" buffer {
nnoremap <Leader>bd :Bdelete<CR>
" }

function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)

function! Setup_gutentags(bn)
    if (match(a:bn,'.exvim$') > -1)
        return 0
    endif
    return 1
endfunction

" tags {
    let $GTAGSLABEL = 'native-pygments'
    let $GTAGSCONF = expand('~/.globalrc')
	" 设定项目目录标志：除了 .git/.svn 外，还有 .vscode 文件
    let g:gutentags_project_root = g:global_RootMarkers
    let g:gutentags_ctags_tagfile = '.tags'
    " let g:gutentags_generate_idutiles = 1
    let g:gutentags_generate_auto = 0

	" 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
    let g:gutentags_cache_dir = expand('~/.cache/tags')
    " let g:gutentags_file_list_command = 'rg --files'
    let g:gutentags_file_list_command = {
                \'default' : 'rg --files',
                \'modules' : {'gsearch' : 'rg --files --null',},
                \}
    "" gutententags
    let g:gutentags_init_user_func = "Setup_gutentags"

	" 默认禁用自动生成
	let g:gutentags_modules = []
    " let g:gutentags_define_advanced_commands = 1
    " let g:gutentags_trace = 1

	" 如果有 ctags 可执行就允许动态生成 ctags 文件
    if executable('ctags')
        let g:gutentags_modules += ['ctags']
    endif

	" 如果有 gtags 可执行就允许动态生成 gtags 数据库
	if executable('gtags') && executable('gtags-cscope')
        let g:gutentags_modules += ['gtags_cscope']
	endif

    let g:gutentags_modules += ['gsearch']

	" 设置 ctags 的参数
    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

	" 使用 universal-ctags 的话需要下面这行，请反注释
    let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

	" 禁止 gutentags 自动链接 gtags 数据库
	" let g:gutentags_auto_add_gtags_cscope = 0
" }

" exvim {
" ex-gsearch
" ---------------------------------------------------

let g:ex_gsearch_ignore_case = 0
call exgsearch#register_hotkey( 100, 0, '<leader>gs', ":EXGSearchToggle<CR>", 'Toggle global search window.' )
call exgsearch#register_hotkey( 101, 0, '<leader>gg', ":EXGSearchCWord<CR>", 'Search current word.' )
call exgsearch#register_hotkey( 102, 0, '<leader>j', ":EXGSearchCWord<CR>", 'Search current word.' )
call exgsearch#register_hotkey( 103, 0, '<leader><S-f>', ":GSW ", 'Shortcut for :GSW' )
call exgsearch#register_hotkey( 103, 0, '<leader>gf', ":GSW ", 'Shortcut for :GSW' )
call exgsearch#register_hotkey( 104, 0, '<leader>ge', ":GSW <C-R>*<CR>", 'Shortcut for :GSW' )
call exgsearch#register_hotkey( 105, 1, 'o', ":call exgsearch#confirm_select('')<CR>"      , 'Go to the search result.' )
call exgsearch#register_hotkey( 106, 1, 'p', ":call exgsearch#confirm_select('shift')<CR>" , 'Go to the search result in split window.' )

" ex-tagselect
" ---------------------------------------------------

call extags#register_hotkey( 100, 0, '<leader>ts', ":EXTagsToggle<CR>", 'Toggle tag select window.' )
call extags#register_hotkey( 101, 0, '<leader>tt', ":EXTagsCWord<CR>", 'Tag select current word.' )
call extags#register_hotkey( 102, 1, 'o', ":call extags#confirm_select('')<CR>"      , 'Go to the search result.' )
call extags#register_hotkey( 103, 1, 'p', ":call extags#confirm_select('shift')<CR>" , 'Go to the search result in split window.' )
"nnoremap <unique> <leader>] :exec 'ts ' . expand('<cword>')<CR>

let g:ex_symbol_select_cmd = 'TS'

" ex-cscope
" ---------------------------------------------------
call excscope#register_hotkey( 100, 0, '<leader>cs', ":EXCSToggle<CR>", 'Toggle cscope window.' )
call excscope#register_hotkey( 101, 0, '<leader>ca', ":CSDD<CR>", 'Find functions called by this function' )
call excscope#register_hotkey( 102, 0, '<leader>cc', ":CSCD<CR>", 'Find functions calling by this function' )
call excscope#register_hotkey( 103, 0, '<leader>cf', ":CSID<CR>", 'Find files #including this file' )
call excscope#register_hotkey( 104, 0, '<leader>cg', ":CSGD<CR>", 'Find this definition' )
call excscope#register_hotkey( 105, 1, 'o', ":call excscope#confirm_select('')<CR>"      , 'Go to the search result.' )
call excscope#register_hotkey( 106, 1, 'p', ":call excscope#confirm_select('shift')<CR>" , 'Go to the search result in split window.' )
"}

" fix colorscheme {

highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
"highlight clear CursorLineNr    " Remove highlight color from current line number
hi VertSplit ctermbg=NONE guibg=NONE
" }

" register / {
function! MakePattern(text)
  let pat = escape(a:text, '\')
  let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
  let pat = substitute(pat, '^\_s\+', '\\s\\*', '')
  let pat = substitute(pat, '\_s\+',  '\\_s\\+', 'g')
  return '\\V' . escape(pat, '\"')
endfunction
vnoremap <silent> <F3> :<C-U>let @/="<C-R>=MakePattern(@*)<CR>"<CR>:set hls<CR>
nnoremap <F3> :let @/='\<\C<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

function! Del_word_delims()
   let reg = getreg('/')
   " After *                i^r/ will give me pattern instead of \<pattern\>
   let res = substitute(reg, '^\\<\(.*\)\\>$', '\1', '' )
   if res != reg
      return res
   endif
   " After * on a selection i^r/ will give me pattern instead of \Vpattern
   let res = substitute(reg, '^\\V'          , ''  , '' )
   let res = substitute(res, '\\\\'          , '\\', 'g')
   let res = substitute(res, '\\n'           , '\n', 'g')
   return res
endfunction

inoremap <silent> <C-R>/ <C-R>=Del_word_delims()<CR>
cnoremap          <C-R>/ <C-R>=Del_word_delims()<CR>
" }

" SynCheck {
" 检测函数（检测光标位置处文字的样式名）
function! SynStack()
    echo map(synstack(line('.'),col('.')),'synIDattr(v:val, "name")')
endfunc

" 绑定检测键位（按键后样式名信息会输出在指令栏的位置）
nnoremap <leader>yi :call SynStack()<CR>
" }

" Strip whitespace {
function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
endfunction
" autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql,lua autocmd BufWritePre <buffer> call StripTrailingWhitespace()
nnoremap <leader>ws :call StripTrailingWhitespace()<CR>
" }

" edit vimrc {
function! ExpandFilenameAndExecute(command, file)
    execute a:command . " " . expand(a:file, ":p")
endfunction

function! EditVimrc13Config()
    call ExpandFilenameAndExecute("tabedit", "$HOME/.vim-self/.vimrc")
    execute bufwinnr(".vimrc") . "wincmd w"
endfunction

noremap <Leader>ev :call EditVimrc13Config()<CR>
noremap <Leader>er :source $HOME/.vim-self/.vimrc<CR>
noremap <Leader>es :NeoSnippetEdit<CR>
" }

" Terminal Config {
  if has('nvim') || exists(':tnoremap') == 2
    exe 'tnoremap <silent><C-Right> <C-\><C-n>:<C-u>wincmd l<CR>'
    exe 'tnoremap <silent><C-Left>  <C-\><C-n>:<C-u>wincmd h<CR>'
    exe 'tnoremap <silent><C-Up>    <C-\><C-n>:<C-u>wincmd k<CR>'
    exe 'tnoremap <silent><C-Down>  <C-\><C-n>:<C-u>wincmd j<CR>'
    exe 'tnoremap <silent><M-Left>  <C-\><C-n>:<C-u>bprev<CR>'
    exe 'tnoremap <silent><M-Right>  <C-\><C-n>:<C-u>bnext<CR>'
    exe 'tnoremap <silent><esc>     <C-\><C-n>'
  endif
  " nnoremap <leader>to :below 20sp term://$SHELL<cr>i
" }

" Code folding options {
noremap <leader>f0 :set foldlevel=0<CR>
" }

" nav {
nnoremap <leader>tj  :tabfirst<CR>
nnoremap <leader>th  :tabnext<CR>
nnoremap <leader>tl  :tabprev<CR>
nnoremap <leader>tk  :tablast<CR>
" nnoremap <leader>tt  :tabedit<Space>
" nnoremap <leader>tn  :tabnext<Space>
nnoremap <leader>tn  :tabnew<CR>
nnoremap <leader>tc  :tabclose<CR>
nnoremap <leader>tm  :tabm<Space>
nnoremap <leader>td  :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap H gT
nnoremap L gt
" Alternatively use
"nnoremap <leader>th :tabnext<CR>
"nnoremap <leader>tl :tabprev<CR>
"nnoremap <leader>tn :tabnew<CR>
" Switch to last-active tab
if !exists('g:Lasttab')
    let g:Lasttab = 1
    let g:Lasttab_backup = 1
endif
autocmd! TabLeave * let g:Lasttab_backup = g:Lasttab | let g:Lasttab = tabpagenr()
autocmd! TabClosed * let g:Lasttab = g:Lasttab_backup
nmap <silent> <Leader>tp :exe "tabn " . g:Lasttab<cr>

for i in range(1,9)
    let s:str = i . ' ' . i
    exec 'nnoremap <leader>t'. s:str .'gt'
    exec 'nnoremap <leader>'. s:str .'<C-W>W'
    exec 'noremap <leader>f' . i  . ' :set foldlevel=' . i . '<CR>'
endfor

nnoremap <leader>if :exec 'normal ,hciw' . expand('%:t:r:r:r') . "\e"<CR>
nnoremap <leader>ip :normal "_cib*

command! OpenInVSCode exe "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
" nnoremap <S-CR> O<Esc>j
" nnoremap <CR> o<Esc>k

" }

" vim:ts=4:sw=4:sts=4 et fdm=marker:
