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
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }


" show icons along file
" must install nerdfonts: https://www.nerdfonts.com/font-downloads
" Plug 'ryanoasis/vim-devicons'

" LSP and completion
" prerequisite
" vim: npm install -g vim-language-server
" python: pip install python-lsp-server
" c++: build ccls
" cmake: pip install cmake-language-server
" dockerfile: npm install -g dockerfile-language-server-nodejs
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

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

" colorscheme
"set t_Co=256 " should be set in .bashrc
syntax enable
colorscheme monokai
"let g:molokai_original = 1 " use molokai backgound color

" terminal
tnoremap <Esc> <C-\><C-n>

"termdebug (lazy load on first use)
command! -nargs=* -complete=file Termdebug silent! packadd termdebug | Termdebug <args>
command! -nargs=* -complete=file TermdebugCommand silent! packadd termdebug | TermdebugCommand <args>
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

" LSP & Completion {{{
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Use `:Format` to format current buffer
command! -nargs=0 Format :lua vim.lsp.buf.format()

lua << EOF
-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- LSP keymaps (set on LspAttach)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { noremap = true, silent = true, buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
    vim.keymap.set('x', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
    vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>qf', vim.diagnostic.setloclist, opts)
  end,
})

-- Advertise cmp capabilities to all LSP servers
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- LSP server configs (migrated from coc-settings.json)
vim.lsp.config('ccls', {
  init_options = {
    cache = { directory = '/tmp/ccls' },
    highlight = { lsRanges = true },
  },
})

vim.lsp.config('pylsp', {
  settings = {
    pylsp = {
      plugins = {
        jedi_completion = { enabled = true },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true, all_scopes = true },
        mccabe = { enabled = true, threshold = 15 },
        preload = { enabled = true },
        pylint = { enabled = false },
        pycodestyle = { enabled = false },
        pydocstyle = { enabled = false },
        pyflakes = { enabled = false },
        rope_completion = { enabled = true },
        yapf = { enabled = true },
      },
    },
  },
})

vim.lsp.config('cmake', {
  init_options = {
    buildDirectory = 'build',
  },
})

vim.lsp.enable({ 'ccls', 'pylsp', 'vimls', 'cmake', 'dockerls' })

-- telescope setup
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = require('telescope.actions').move_selection_next,
        ['<C-k>'] = require('telescope.actions').move_selection_previous,
      },
    },
  },
})
require('telescope').load_extension('fzf')
EOF
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

" telescope.nvim {{{
" prerequisite: ripgrep (for live_grep)
nmap <Leader>f <cmd>Telescope git_files<cr>
nmap <Leader>F <cmd>Telescope find_files<cr>
" search buffers
nmap <Leader>b <cmd>Telescope buffers<cr>
nmap <Leader>h <cmd>Telescope oldfiles<cr>
" search tags
nmap <Leader>t <cmd>Telescope current_buffer_tags<cr>
nmap <Leader>T <cmd>Telescope tags<cr>
" search lines
nmap <Leader>l <cmd>Telescope current_buffer_fuzzy_find<cr>
nmap <Leader>L <cmd>Telescope live_grep<cr>
nmap <Leader>' <cmd>Telescope marks<cr>
" search projects
nmap <Leader>/ <cmd>Telescope live_grep<cr>
" search helps
nmap <Leader>H <cmd>Telescope help_tags<cr>
" search commands
nmap <Leader>C <cmd>Telescope commands<cr>
" search commands history
nmap <Leader>: <cmd>Telescope command_history<cr>
" }}}
" }}}
