set nocompatible              " be iMproved, required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Plugins {{{
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')
" general
" File Explorer
Plug 'preservim/nerdtree'
" Display git sign along with filename
Plug 'Xuyuanp/nerdtree-git-plugin'
" custome status line
Plug 'vim-airline/vim-airline'
" display igit sign along with line number
Plug 'airblade/vim-gitgutter'
" show git message
Plug 'rhysd/git-messenger.vim'
" use git in vim
Plug 'tpope/vim-fugitive'
" surround text object
Plug 'tpope/vim-surround'

" automatic save vim session
Plug 'tpope/vim-obsession'

" custom start screen
Plug 'mhinz/vim-startify'

" Fuzzy search
" prerequisite: https://github.com/junegunn/fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Automatic run ctags
" prerequisite: https://github.com/universal-ctags/ctags
Plug 'ludovicchabant/vim-gutentags'

" show tags in split
Plug 'preservim/tagbar'

" show icons along file
" must install nerdfonts: https://www.nerdfonts.com/font-downloads
" Plug 'ryanoasis/vim-devicons'

" async code completion by language server
" prerequisite
" vim: npm install -g vim-language-server
" python: pip install python-lsp-server
" c++: build ccls
" cmake: pip install cmake-language-server
" dockerfile: npm install -g dockerfile-language-server-nodejs
" json: :CocInstall coc-json
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" json comments support
Plug 'neoclide/jsonc.vim'

" Snippets, works with CocInstall coc-snippets
Plug 'honza/vim-snippets'

" color schemes
Plug 'flazz/vim-colorschemes'
Plug 'sickill/vim-monokai'

" lint engine
" Plug 'w0rp/ale'

" vim-tmux navigator
Plug 'christoomey/vim-tmux-navigator'

" Initialize plugin system
call plug#end()
" }}}

" Vim Settings {{{
" fold
set foldmethod=indent
autocmd Filetype vim setlocal foldmethod=marker
" open 5 levels of folds automattically when open file
set foldlevel=5
" show line numbers
set number
set numberwidth=5
" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1
" Highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn
" Display extra whitespace
set list listchars=tab:»·,trail:·
" Set search display style
set matchpairs+=<:>
set hlsearch " highlight search result
" Display incomplete commands
set showcmd

" Map leader to <Space>
map <SPACE> <leader>
" Backspace deletes like most programs in insert mode
set backspace=2
" Set fileencodings
set fileencodings=utf-8,bg18030,gbk,big5
" Using System Clipboard
"nmap <leader>p "+p
"nmap <leader>y "+y

" Always display the status line
set laststatus=2

" Buffer Settings {{{
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden
" Quicker movement between buffers
nnoremap <silent> bh :bprevious<CR>
nnoremap <silent> bl :bnext<CR>
nnoremap <silent> bH :bfirst<CR>
nnoremap <silent> bL :blast<CR>
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nnoremap bn :enew<cr>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nnoremap bq :bp <BAR> bd #<CR>
" type Ngb to buffer number N
let c = 1
while c <= 99
  execute "nnoremap " . c . "gb :" . c . "b\<CR>"
  let c += 1
endwhile
" }}}

" Windows(Split) Settings {{{
" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Split window and keep focus in original window
nnoremap ss :split<Return><C-w>w
nnoremap sv :vsplit<Return><C-w>w

" Resize window
nnoremap s<left> <C-w><
nnoremap s<right> <C-w>>
nnoremap s<up> <C-w>+
nnoremap s<down> <C-w>-
" }}}

" convert TAB to Spaces
" by default, the indent is 2 spaces
set shiftwidth=2 " this controlls how many spaces will be used with autoindent
set expandtab   " make Vim to insert with spaces instead of tabs
set tabstop=2 " set number of spaces to be used
set softtabstop=2 " delete how many spaces when stroke backspace 
" set tab width for different filetype
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype python setlocal ts=4 sts=4 sw=4
autocmd Filetype cpp setlocal ts=4 sts=4 sw=4
"autocmd Filetype javascript setlocal ts=4 sts=4 sw=4
" don't convert tab when edit Makefile
autocmd FileType make setlocal noexpandtab

" disable markdown hightlight
autocmd BufRead,BufNewFile {*.markdown,*.mdown,*.mkdn,*.md,*.mkd,*.mdwn,*.mdtxt,*.mdtext,*.text} set filetype=markdown
autocmd FileType markdown setlocal syntax=off

" set tags path
" search current file directory firstly
" search vim :pwd directory secondly
set tags=./.tags;,.tags

" colorscheme
"set t_Co=256 " should be set in .bashrc
syntax enable
colorscheme monokai
"let g:molokai_original = 1 " use molokai backgound color

" terminal
tnoremap <Esc> <C-\><C-n>

"termdebug
packadd termdebug
" }}}

" Plugin Settings {{{
" NERD tree {{{
let NERDChristmasTree=0
let NERDTreeWinSize=35
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
let NERDTreeShowBookmarks=1
let NERDTreeWinPos="left"
" Automatically open a NERDTree if opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | wincmd p | ene | exe 'NERDTree' argv()[0] | endif
" Automatically close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Open a NERDTree
nmap <F5> :NERDTreeToggle<CR>
" }}}

" NERD tree git plugin {{{
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "M",
    \ "Staged"    : "S",
    \ "Untracked" : "N",
    \ "Renamed"   : "R",
    \ "Unmerged"  : "U",
    \ "Deleted"   : "D",
    \ "Dirty"     : "M",
    \ "Clean"     : "√",
    \ 'Ignored'   : '!',
    \ "Unknown"   : "?"
    \ }
" }}}

" COC {{{
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=1

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
"nmap <silent> <C-d> <Plug>(coc-range-select)
"xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" }}}

" tagbar {{{
let g:tagbar_width=35
let g:tagbar_autofocus=1
nmap <F6> :TagbarToggle<CR>
" }}}

" Airline: {{{
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show collapsed directories and filename
let g:airline#extensions#tabline#formatter = 'default'
" Show buffer number in title
let g:airline#extensions#tabline#buffer_nr_show = 1
" }}}

" Startify: {{{
let g:starship= [
      \ "                   .      *                .       ",
      \ "     __ _o|                        .               ",
      \ "    |  /__|===--        .             +            ",
      \ "    [__|______~~--._                      .        ",
      \ "   |\  `---.__:====]-----...,,_____               *",
      \ "   |[>-----|_______<----------_____;::===--        ",
      \ "   |/_____.....-----'''~~~~~~~                  .  ",
      \ "              .                      All Ahead Full",
      \ "",
      \]
let g:startify_custom_header = g:starship
" }}}

" vim-gutentags: {{{
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 只扫描加入git库的代码
let g:gutentags_file_list_command = 'git ls-files'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
"let s:vim_tags = expand('~/.cache/tags')
" 检测 ~/.cache/tags 不存在就新建
"if !isdirectory(s:vim_tags)
"   silent! call mkdir(s:vim_tags, 'p')
"endif
"let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" }}}

" vim-tmux-navigator: {{{
" unify movement between vim splits and tmux panes
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<cr>
" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2
" }}}

" fzf.vim {{{
" search files
nmap <Leader>f :GFiles<CR>
nmap <Leader>F :Files<CR>
" search buffers
nmap <Leader>b :Buffers<CR>
nmap <Leader>h :History<CR>
" search tags
nmap <Leader>t :BTags<CR>
nmap <Leader>T :Tags<CR>
" search lines
nmap <Leader>l :BLines<CR>
nmap <Leader>L :Lines<CR>
nmap <Leader>' :Marks<CR>
" search projects
nmap <Leader>/ :Ag<Space>
" nmap <Leader>/ :Rg<Space>
" search helps
nmap <Leader>H :Helptags!<CR>
" search commands
nmap <Leader>C :Commands<CR>
" search commands history
nmap <Leader>: :History:<CR>
" }}}
" }}}
