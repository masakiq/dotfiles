" ## Vimscript file settings ---------------------- {{{

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" }}}

" ## 基本設定 ---------------------- {{{

" vi 非互換
set nocompatible

" フォーマット設定
set encoding=utf-8
set fileformats=unix,dos,mac

" }}}

" ## 検索の挙動に関する設定 ---------------------- {{{

" 検索時に大文字小文字を無視 (noignorecase:無視しない)
" set ignorecase

" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

" インクリメンタルサーチ
set incsearch

" 検索ハイライト
set hlsearch

" ビジュアルモードで選択したときに、検索した単語をハイライトにする
" syn match cppSTL /\(::.*\)\@<=\<find\>/

" :vim(grep) したときに自動的にquickfix-windowを開く
autocmd QuickFixCmdPost *grep* cwindow
" quickfix-window のサイズ調整
autocmd FileType qf 15wincmd_

" 検索時のハイライトを無効化
set nohlsearch

" }}}

" ## カーソル移動に関する設定 ---------------------- {{{

" スクロールオフ
set scrolloff=15

" マウススクロール
set mouse=a

" }}}

" ## 編集に関する設定 ---------------------- {{{

" タブの画面上での幅
set tabstop=2

" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=2

" 自動インデントでずれる幅
set shiftwidth=2

" タブをスペースに展開する/ しない (expandtab:展開する)
set expandtab

" 自動的にインデントする (noautoindent:インデントしない)
set autoindent

" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start

" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan

" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch

" コマンドライン補完するときに強化されたものを使う
set wildmenu
set wildmode=longest:full,full

" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

" タイポチェック
set spell spelllang+=cjk
" set nospell

" バッファ切り替え時のワーニングを無視
set hidden

" 保存時に行末空白削除
autocmd BufWritePre * if &filetype != 'markdown' | :%s/\s\+$//ge | endif

" Undo の永続化
if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
  exe 'set undodir=' .. undo_path
  set undofile
endif

" }}}

" ## ファイル操作に関する設定 ---------------------- {{{

" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set nobackup

" スワップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set noswapfile

" 新しいウィンドウを下に開く
set splitbelow

" 新しいウィンドウを右に開く
set splitright

" }}}

" ## カスタムマッピング ---------------------- {{{

" ### マップ基本設定 ---------------------- {{{

" リーダーキーを , にする
let mapleader = ','

" ローカルリーダーキーを , にする
" let maplocalleader = ","

" リーダーキーのディレイタイム
set timeout timeoutlen=800 ttimeoutlen=100

inoremap jk <esc>
inoremap <silent> ｊｋ <esc>
inoremap <C-c> <esc>
vnoremap <C-c> <esc>

nnoremap あ a
nnoremap い i
nnoremap お o

" 以下はクリップボードが正常に働かなくなる
" :inoremap <esc> <nop>
" :inoremap <c-[> <nop>

" Insert モードで Emacs のキーバインドを使えるようにする
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <C-h> <BS>
inoremap <C-a> <Home>
inoremap <C-k> <esc>`^DA

" 方向キーとバックスペースキーを無効にする
vnoremap <Up>    <nop>
vnoremap <Down>  <nop>
vnoremap <Left>  <nop>
vnoremap <Right> <nop>
vnoremap <Bs>    <nop>
inoremap <Up>    <nop>
inoremap <Down>  <nop>
inoremap <Left>  <nop>
inoremap <Right> <nop>
" inoremap <Bs>    <nop> for multi cursor
nnoremap <Up>    <nop>
nnoremap <Down>  <nop>
nnoremap <Left>  <nop>
nnoremap <Right> <nop>
nnoremap <Bs>    <nop>
tnoremap <Up>    <nop>
tnoremap <Down>  <nop>
tnoremap <Left>  <nop>
tnoremap <Right> <nop>
tnoremap <Bs>    <nop>

" ビジュアルモードで単語の最後まで選択する
vnoremap E $h
" ビジュアルモードでライン選択(ただし行末の改行は除く)
vnoremap V 0<esc>v$h

vnoremap a <esc>G$vgg0

nnoremap V 0v$h

" インサートモードを抜けるときに IME を "英数" に切り替える
" https://mitsuse.jp/2017/01/02/disable-input-source-on-insert-leave-in-vim/
if executable('swim')
  autocmd InsertLeave * :call system('swim use com.apple.keylayout.ABC')
endif

" }}}

" ### 表示系 ---------------------- {{{

nnoremap <space>i :set hlsearch!<CR>
nnoremap <space>n :call ToggleDisplayNumber()<cr>

" }}}

" ### クリップボード系 ---------------------- {{{

" ビジュアルモードで選択した範囲をクリップボードにコピー
vnoremap y "+y
" ビジュアルモードで選択した範囲にクリップボードからペースト
vnoremap p "+p
" ビジュアルモードで選択した範囲をカットしてクリップボードにコピー　
vnoremap d "+d
" ビジュアルモードで選択した範囲をカットしてクリップボードにコピー　
vnoremap x "+x
" ビジュアルモードで選択した箇所の末尾までクリップボードにコピー　
" vnoremap <leader>y $h"+y
" ビジュアルモードで選択した箇所の末尾までクリップボードからペースト
" vnoremap <leader>p $h"+p
" ビジュアルモードで選択した箇所の末尾までカットしてクリップボードにコピー
" vnoremap <leader>d $h"+d
" ビジュアルモードで選択した箇所の末尾までカットしてクリップボードにコピー
" vnoremap <leader>x $h"+x

" HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れる
vnoremap fy :call ChangeToFileFormatAndCopy()<cr>w

" message をコピーする
nnoremap <space>m :let @+ =execute('1messages')<CR>:echo 'last messages copied!'<CR>

nnoremap <space>c :CopyCurrentPath<cr>

" }}}

" ### 移動系 ---------------------- {{{

nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk
nnoremap 0 g0
vnoremap 0 g0
nnoremap ^ g^
vnoremap ^ g^
nnoremap $ g$
" vnoremap $ g$

nnoremap <C-e> $a
nnoremap <C-a> ^i

nnoremap <C-u> 5k
nnoremap <C-d> 5j

" }}}

" ### 変換系 ---------------------- {{{

" 選択した両側を指定した記号で囲む　
vnoremap ' c'<C-r>"'<Esc>
vnoremap " c"<C-r>""<Esc>
vnoremap ` c`<C-r>"`<Esc>
vnoremap ( c(<C-r>")<Esc>
vnoremap ) c(<C-r>")<Esc>
vnoremap [ c[<C-r>"]<Esc>
vnoremap ] c[<C-r>"]<Esc>
vnoremap { c{<C-r>"}<Esc>
vnoremap } c{<C-r>"}<Esc>
vnoremap < c<<C-r>"><Esc>
vnoremap > c<<C-r>"><Esc>
vnoremap * c*<C-r>"*<Esc>
vnoremap ~ c~<C-r>"~<Esc>
vnoremap <space> c<space><C-r>" <Esc>
" 選択した両側を一文字ずつ削除
vnoremap <bs> c<Right><Bs><Bs><C-r>"<Esc>

" }}}

" ### 補完系 ---------------------- {{{

" 補完時の挙動を一般的な IDE と同じにする
set completeopt=menuone,noinsert
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"
inoremap <expr><C-j> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-k> pumvisible() ? "<Up>" : "<C-p>"

" }}}

" ### ファイル操作系 ---------------------- {{{

nnoremap <space>w :w!<cr>
nnoremap <space>q :q!<cr>

" }}}

" ### ウィンドウ操作系 ---------------------- {{{

" ウインドウ間移動
nnoremap <space>h <c-w>h
nnoremap <space>j <c-w>j
nnoremap <space>k <c-w>k
nnoremap <space>l <c-w>l

" ウインドウ幅を右に広げる
nnoremap <space>. 41<c-w>>
" ウインドウ幅を左に広げる
nnoremap <space>, 41<c-w><
" ウインドウ高さを高くする
nnoremap <space>= 9<c-w>+
" ウインドウ高さを低くする
nnoremap <space>- 9<c-w>-

" 前のバッファに戻る
" nnoremap <space><left> :bprevious<CR>
" 次のバッファに進む
" nnoremap <space><right> :bnext<CR>

" }}}

" ### タブ操作系 ---------------------- {{{

" 新規タブを開く
nnoremap <space>t :tabnew<CR>

if has('gui_running')
else
  nnoremap <right> :normal gt<CR>
  " 左のタブに移動
  nnoremap <left> :normal gT<CR>

  " 現タブを右に移動
  nnoremap <space><right> :+tabm<CR>
  " 現タブを左に移動
  nnoremap <space><left> :-tabm<CR>
endif

" }}}

" ### 検索系 ---------------------- {{{

nnoremap <space>/ :call SearchByRG()<cr>
vnoremap <space>/ :call RGBySelectedText()<cr>

" }}}

" ### セッション系 ---------------------- {{{

nnoremap <space>os :call OpenSession()<cr>

" }}}

" ### ターミナルモード ---------------------- {{{

" カレントウィンドウでターミナルを開く
" nnoremap <space>ec :ter ++curwin<CR>

if has('nvim')
  tnoremap jf <C-\><C-n>
else
  tnoremap jf <C-w>N
endif

" }}}

" ### quickfix ---------------------- {{{

nnoremap <space>; :colder<CR>
nnoremap <space>' :cnewer<CR>

" }}}

" }}}

" ## スニペット設定 ---------------------- {{{

" Ruby 用スニペット
autocmd FileType ruby :iabbrev fro # frozen_string_literal: true<esc>
autocmd FileType ruby :iabbrev yar # @param options [Type] description<CR>@return [Type] description<CR>@raise [StandardError] description<CR>@option options [Type] description<CR>@example description<CR>@yield [Type] description<esc>6k4w
autocmd FileType ruby :iabbrev con context '' do<CR>end<esc>kw<esc>
autocmd FileType ruby :iabbrev des describe '' do<CR>end<esc>kw<esc>
autocmd FileType ruby :iabbrev let let(:) { }<esc>4hi<esc>
autocmd FileType ruby :iabbrev sha shared_examples '' do<CR>end<esc>kw<esc>
autocmd FileType ruby :iabbrev beh it_behaves_like ''<esc>h<esc>
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd FileType markdown :iabbrev tab <table><CR><esc>i  <thead><CR><esc>i    <tr><CR><esc>i      <th colspan="2"></th><CR><esc>i    </tr><CR><esc>i  </thead><CR><esc>i  <tbody><CR><esc>i    <tr><CR><esc>i      <td></td><CR><esc>i      <td></td><CR><esc>i    </tr><CR><esc>i  </tbody><CR><esc>i</table><esc>

" }}}

" ## プラグイン設定 ---------------------- {{{

call plug#begin('~/.vim/plugged')
" ---- Do not change the following lines ----
Plug 'junegunn/fzf', { 'dir': '~/.fzf', '   do': './install --all' }
" -------------------------------------------
Plug 'skywind3000/asyncrun.vim',            { 'commit': '168d6b4be9d003ed14ef5d0e1668f01145327e68' }
Plug 'jiangmiao/auto-pairs',                { 'commit': '39f06b873a8449af8ff6a3eee716d3da14d63a76' }
Plug 'neoclide/coc.nvim',                   { 'commit': '0480cbd9976529f69aeb692d8e1834d3edde90c5' }
Plug 'dart-lang/dart-vim-plugin',           { 'commit': '08764627ce85fc0c0bf9d8fd11b3cf5fc05d58ba', 'for': 'dart' }
Plug 'dracula/vim',                         { 'commit': 'e5f09746562ef0226d3484a01609ceca41700a3d', 'as': 'dracula' }
Plug 'lambdalisue/fern.vim',                { 'commit': 'dd365ec17e9ff1d87a5ce4ade8abf123ecfd007a' }
Plug 'junegunn/fzf.vim',                    { 'commit': 'd6aa21476b2854694e6aa7b0941b8992a906c5ec' }
Plug 'haya14busa/incsearch-easymotion.vim', { 'commit': 'fcdd3aee6f4c0eef1a515727199ece8d6c6041b5' }
Plug 'haya14busa/incsearch-fuzzy.vim',      { 'commit': 'b08fa8fbfd633e2f756fde42bfb5251d655f5403' }
Plug 'haya14busa/incsearch.vim',            { 'commit': '25e2547fb0566460f5999024f7a0de7b3775201f' }
Plug 'tyru/open-browser.vim',               { 'commit': '80ec3f2bb0a86ac13c998e2f2c86e16e6d2f20bb', 'for': 'markdown' }
Plug 'previm/previm',                       { 'commit': '0bc7677d492f75eff60757496c899b00e8a3855f', 'for': 'markdown' }
Plug 'tpope/vim-commentary',                { 'commit': '627308e30639be3e2d5402808ce18690557e8292' }
Plug 'easymotion/vim-easymotion',           { 'commit': 'd75d9591e415652b25d9e0a3669355550325263d' }
Plug 'tpope/vim-fugitive',                  { 'commit': '2064312ad7bb80050baf9acbdfb7641162919e53' }
Plug 'ruanyl/vim-gh-line',                  { 'commit': 'd2185b18883b911a21b684d4bb9d26f6a41b62f4' }
Plug 'maxmellon/vim-jsx-pretty',            { 'commit': '6989f1663cc03d7da72b5ef1c03f87e6ddb70b41', 'for': ['javascript', 'typescript'] }
Plug 'mtdl9/vim-log-highlighting',          { 'commit': '1037e26f3120e6a6a2c0c33b14a84336dee2a78f' }
Plug 'mattn/vim-maketable',                 { 'commit': 'f2210dae1ca6fed07881de8e3f95a7bca1a7b4a8' }
Plug 'rcmdnk/vim-markdown',                 { 'commit': 'd58fef2c76ec3d3ef6b6be90c3f53d1657bb4512', 'for': 'markdown' }
Plug 'matze/vim-move',                      { 'commit': '6442747a3d3084e3c1214388192b8308fcf391b8' }
Plug 'masakiq/vim-ruby-fold',               { 'commit': 'b8c35810a94bb2976d023ece2b929c8a9279765b', 'for': 'ruby' }
Plug 'tpope/vim-surround',                  { 'commit': 'aeb933272e72617f7c4d35e1f003be16836b948d' }
Plug 'masakiq/vim-tabline',                 { 'commit': 'ddebfdd25e6de91e3e89c2ec18c80cd3d2adadd9' }
Plug 'vim-test/vim-test',                   { 'commit': '8d942aa3b0eea1d53cccd1ee87a241b651f485ee' }
Plug 'mg979/vim-visual-multi',              { 'commit': 'e20908963d9b0114e5da1eacbc516e4b09cf5803' }
Plug 'liuchengxu/vim-which-key',            { 'commit': '165772f440bd26c4679eef8b8b493ab11fffc4ae' }
call plug#end()

" }}}

" ## 画面表示に関する設定 ---------------------- {{{

" シンタックス
syntax enable
" タイトルを表示する

set title

" 行番号を表示 (nonumber:非表示)
set number

" ルーラーを表示 (noruler:非表示)
set ruler

" タブや改行を表示 (list:表示)
set nolist

" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<

" 長い行を折り返して表示
set wrap

" 常にステータス行を表示
set laststatus=2

" コマンドラインの高さ
set cmdheight=1

" コマンドをステータス行に表示
set showcmd

" モードを表示する
set showmode

" 画面のカラースキーマCygwinでみやすい色使い
" colorscheme  tortetorte

" アンダーライン
set cursorline

" autocmd TerminalOpen * set nonu

" ファイルを読み込み
set autoread

" 最初は折りたたむ
au BufRead * normal zR

" カラースキーマ設定
colorscheme dracula

"augroup BgHighlight
"  autocmd!
"  autocmd WinEnter * set cul
"  autocmd WinLeave * set nocul
"augroup END

" シンタックスエラーを下線にする
hi clear SpellBad
hi SpellBad cterm=underline
hi SpellCap cterm=underline
hi SpellRare cterm=underline
hi SpellLocal cterm=underline

" Background color
hi Normal               ctermfg=none ctermbg=none
" hide the `~` at the start of an empty line
hi EndOfBuffer          ctermfg=16 ctermbg=none
" hi NonText ctermbg=238

" fold した行に `-` を付与しないための設定
" https://vi.stackexchange.com/questions/14217/how-to-hide-horizontal-line-between-windows#answer-14222
" set fillchars=stl:_     " fill active window's statusline with _
" set fillchars+=stlnc:_  " also fill inactive windows
" ウィンドウ間のバーをカスタマイズ
hi VertSplit ctermfg=16 ctermbg=16
set fillchars+=vert:│

" 補完の色調整
hi Pmenu ctermfg=4 ctermbg=0
hi PmenuSel ctermfg=243 ctermbg=45
hi PmenuSbar ctermbg=238 ctermfg=238
hi PmenuThumb ctermbg=248 ctermfg=248

hi Folded               ctermfg=44  ctermbg=241
hi WildMenu             ctermfg=238 ctermbg=87

hi StatusLine           ctermfg=87  ctermbg=238
hi StatusLineNC         ctermfg=31  ctermbg=238

hi SpellCap             ctermfg=87  ctermbg=31
hi SpellRare            ctermfg=87  ctermbg=63
hi SpellLocal           ctermfg=87  ctermbg=71
hi Error                ctermfg=255 ctermbg=199
hi Search               ctermfg=255 ctermbg=63
hi Todo                 ctermfg=255 ctermbg=34
hi Visual               ctermfg=255 ctermbg=38

hi DiffAdd    cterm=none ctermfg=45  ctermbg=none
hi DiffDelete cterm=none ctermfg=45  ctermbg=none
hi DiffChange cterm=none ctermfg=45  ctermbg=none
hi DiffText   cterm=none ctermfg=191 ctermbg=none

hi Identifier           ctermfg=115
hi Type                 ctermfg=45
hi PreProc              ctermfg=219
hi Constant             ctermfg=147
hi Statement            ctermfg=199
hi CursorColumn         ctermbg=19
hi lscCurrentParameter  ctermbg=19
hi SignColumn           ctermbg=0

hi LineNr               ctermfg=31  ctermbg=none
hi CursorLineNr         ctermfg=87  cterm=none
hi CursorLine           ctermbg=237 cterm=none

" For coc.nvim
hi CocFloating                      ctermfg=255   ctermbg=239
hi FgCocInfoFloatBgCocFloating      ctermfg=123   ctermbg=239
hi FgCocWarningFloatBgCocFloating   ctermfg=230   ctermbg=239
hi FgCocErrorFloatBgCocFloating     ctermfg=219   ctermbg=239

" タブ
hi TabLineSel           ctermfg=87  cterm=none
hi TabLine              ctermfg=31  ctermbg=none cterm=none
hi TabLineFill          ctermfg=31  ctermbg=none cterm=none

" txt ファイルの highlight
autocmd BufRead,BufNewFile *.txt set syntax=conf

hi Comment  ctermfg=White

" 非アクティブのときに白くする
"hi ColorColumn ctermbg=237
"if exists('+colorcolumn')
"  function! s:DimInactiveWindows()
"    for i in range(1, tabpagewinnr(tabpagenr(), '$'))
"      let l:range = ""
"      if i != winnr()
"        if &wrap
"         " HACK: when wrapping lines is enabled, we use the maximum number
"         " of columns getting highlighted. This might get calculated by
"         " looking for the longest visible line and using a multiple of
"         " winwidth().
"         let l:width=256 " max
"        else
"         let l:width=winwidth(i)
"        endif
"        let l:range = join(range(1, l:width), ',')
"      endif
"      call setwinvar(i, '&colorcolumn', l:range)
"    endfor
"  endfunction
"  augroup DimInactiveWindows
"    au!
"    au WinEnter * call s:DimInactiveWindows()
"    au WinEnter * set cursorline
"    "au WinEnter * highlight LineNr ctermfg=31  ctermbg=0
"    au WinLeave * set nocursorline
"    "au WinLeave * highlight LineNr ctermfg=31  ctermbg=238
"  augroup END
"endif

" }}}

" ### plugin liuchengxu/vim-which-key ---------------------- {{{

if has('gui_running')
else
  let g:which_key_map =  {}
  call which_key#register('<space>', "g:which_key_map")
  call which_key#register('<leader>', "g:which_key_map")
  nnoremap <silent> <space> :WhichKey '<space>'<CR>
  nnoremap <silent> <leader> :WhichKey '<leader>'<CR>
  vnoremap <silent> <space> :<c-u>WhichKeyVisual '<space>'<CR>
  vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<leader>'<CR>
  set timeoutlen=200
  let g:which_key_use_floating_win = 1
  " let g:which_key_vertical = 1
  highlight WhichKeyFloating ctermbg=232
  autocmd FileType which_key highlight WhichKey ctermfg=13
  autocmd FileType which_key highlight WhichKeySeperator ctermfg=14
  autocmd FileType which_key highlight WhichKeyGroup ctermfg=11
  autocmd FileType which_key highlight WhichKeyDesc ctermfg=10
  let g:which_key_map.q = 'Quit'
  let g:which_key_map.h = 'Move left'
  let g:which_key_map.j = 'Move down'
  let g:which_key_map.k = 'Move up'
  let g:which_key_map.l = 'Move right'
  let g:which_key_map.t = 'Tab new'
  let g:which_key_map['<Right>'] = 'Expand right'
  let g:which_key_map['<Left>'] = 'Expand left'
  let g:which_key_map['<Up>'] = 'Expand up'
  let g:which_key_map['<Down>'] = 'Expand down'
endif

" }}}

" ### plugin ruanyl/vim-gh-line ---------------------- {{{

if has('gui_running')
else
  let g:gh_line_map_default = 0
  let g:gh_line_blame_map_default = 1
  " let g:gh_line_map = '<space>gf'
  " let g:gh_line_blame_map = '<space>gb'
endif

" }}}

" ### plugin easymotion/vim-easymotion ---------------------- {{{

" map  f <Plug>(easymotion-bd-f)
" nmap <space>f <Plug>(easymotion-overwin-f)
nmap f <Plug>(easymotion-overwin-f2)
" nmap f <Plug>(easymotion-sn)
let g:EasyMotion_smartcase = 1

" Migemo (日本語用)
" https://github.com/easymotion/vim-easymotion#migemo-feature-for-japanese-user
" <Leader><Leader>sa で「あ」を検索する
let g:EasyMotion_use_migemo = 1

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
        \   'converters': [incsearch#config#fuzzyword#converter()],
        \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
        \   'keymap': {"\<CR>": '<Over>(easymotion)'},
        \   'is_expr': 0,
        \   'is_stay': 1
        \ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> <space>f incsearch#go(<SID>config_easyfuzzymotion())

" }}}

" ## plugin kannokanno/previm ---------------------- {{{

autocmd BufRead,BufNewFile *.mkd  set filetype=markdown
autocmd BufRead,BufNewFile *.md  set filetype=markdown
command! -nargs=0 OpenMarkdown call OpenMarkdown()
function! OpenMarkdown()
  PrevimOpen
endfunction
" 自動で折りたたまないようにする
let g:vim_markdown_folding_disabled=1
let g:previm_enable_realtime = 1

" }}}

" ## dart-lang/dart-vim-plugin ---------------------- {{{

let dart_html_in_string = v:true
let g:dart_style_guide = 2
" let g:dart_format_on_save = 1

" }}}

" ## dense-analysis/ale ---------------------- {{{

" let g:ale_lint_on_text_changed = 0
" let g:ale_linters = {
"       \ 'dart': ['dartfmt'],
"       \ 'ruby': ['rubocop'],
"       \ }
" let g:ale_fixers = {
"       \ 'dart': ['dartfmt'],
"       \ 'ruby': ['rubocop'],
"       \}
" let g:ale_fix_on_save = 0
"
" command! -nargs=0 DisableLinterOnSave call DisableLinterOnSave()
" function! DisableLinterOnSave()
"   let g:ale_fix_on_save = 0
"   echo 'disable linter'
" endfunction
"
" command! -nargs=0 EnableLinterOnSave call EnableLinterOnSave()
" function! EnableLinterOnSave()
"   let g:ale_fix_on_save = 1
"   echo 'enable linter'
" endfunction

" }}}

" ## skywind3000/asyncrun.vim ---------------------- {{{

noremap <space>a :call asyncrun#quickfix_toggle(20)<cr>

" }}}

" ## mg979/vim-visual-multi ---------------------- {{{

let g:VM_maps = {}
"let g:VM_maps["Align"]                = '<M-a>'
let g:VM_maps["Align"]                = 'A'
let g:VM_maps["Surround"]             = 'S'
let g:VM_maps["Case Conversion Menu"] = 'C'

" }}}

" ## masakiq/vim-tabline ---------------------- {{{

let g:tabline_charmax = 40

" }}}

" ## lambdalisue/fern.vim ---------------------- {{{

noremap <space>oe :Fern . -drawer -width=50 -toggle -keep -reveal=%<CR>
let g:fern#mark_symbol                       = '●'
let g:fern#renderer#default#collapsed_symbol = '▷ '
let g:fern#renderer#default#expanded_symbol  = '▼ '
let g:fern#renderer#default#leading          = ' '
let g:fern#renderer#default#leaf_symbol      = ' '
let g:fern#renderer#default#root_symbol      = '~ '

function! FernInit() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
  nmap <buffer> n <Plug>(fern-action-new-path)
  nmap <buffer> d <Plug>(fern-action-remove)
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)
endfunction

augroup FernGroup
  autocmd!
  autocmd FileType fern call FernInit()
augroup END

" }}}

" ## matze/vim-move ---------------------- {{{

let g:move_map_keys = 0
" let g:move_auto_indent = 0
let g:move_past_end_of_line = 0
nmap <C-j> <Plug>MoveLineDown
nmap <C-k> <Plug>MoveLineUp
vmap <C-j> <Plug>MoveBlockDown
vmap <C-k> <Plug>MoveBlockUp
vmap <C-h> <Plug>MoveBlockLeft
vmap <C-l> <Plug>MoveBlockRight

" }}}

" ## masakiq/vim-ruby-fold ---------------------- {{{

let g:ruby_fold_lines_limit = 300

" }}}

"## maxmellon/vim-jsx-pretty ---------------------- {{{

let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" }}}

"## vim-test/vim-test ---------------------- {{{

nnoremap <leader>t :RunTest<cr>

command! -nargs=0 RunTest :TestFile<cr>
command! -nargs=0 RunTestNearest :TestNearest<cr>

function! DockerTransformer(cmd) abort
  let services_name = system("docker-compose ps --services | grep spring")
  if matchstr(services_name, "spring") == "spring"
    return 'docker-compose exec ' . substitute(services_name, "\n", "", "") . ' spring ' . a:cmd
  elseif matchstr(services_name, "api") == "api"
    return 'docker-compose exec ' . substitute(services_name, "\n", "", "") . ' ' . a:cmd
  elseif matchstr(services_name, "web") == "web"
    return 'docker-compose exec ' . substitute(services_name, "\n", "", "") . ' ' . a:cmd
  else
    return a:cmd
  endif
endfunction

let g:test#custom_transformations = {'docker': function('DockerTransformer')}
let g:test#transformation = 'docker'
let g:test#strategy = 'neovim'
let g:test#neovim#start_normal = 1
let test#ruby#rspec#executable = 'rspec'

" }}}

"## tpope/vim-commentary ---------------------- {{{

" noremap <space>c :Commentary<cr>
noremap <leader>c :Commentary<cr>

" }}}

" ## fzf 設定 ---------------------- {{{

command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)
function! s:GotoOrOpen(command, ...)
  for file in a:000
    if a:command == 'e'
      exec 'e ' . file
    else
      exec "tab drop " . file
    endif
  endfor
endfunction

let g:fzf_buffers_jump = 1

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 } }
let g:fzf_action = {
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-e': 'edit',
      \ 'enter': 'GotoOrOpen tab',
      \ }

let g:fzf_colors =
      \ { "fg":      ["fg", "Normal"],
      \ "bg":      ["bg", "Normal"],
      \ "hl":      ["fg", "IncSearch"],
      \ "fg+":     ["fg", "CursorLine", "CursorColumn", "Normal"],
      \ "bg+":     ["bg", "CursorLine", "CursorColumn"],
      \ "hl+":     ["fg", "IncSearch"],
      \ "info":    ["fg", "IncSearch"],
      \ "border":  ["fg", "Normal"],
      \ "prompt":  ["fg", "Comment"],
      \ "pointer": ["fg", "IncSearch"],
      \ "marker":  ["fg", "IncSearch"],
      \ "spinner": ["fg", "IncSearch"],
      \ "header":  ["fg", "WildMenu"] }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(
      \   <q-args>,
      \   fzf#vim#with_preview(
      \     {
      \       'options': [
      \         '--layout=reverse',
      \         '--info=inline',
      \         '--bind=ctrl-u:toggle,ctrl-p:toggle-preview'
      \       ]
      \     }
      \   ),
      \   <bang>0
      \ )
command! -bang -nargs=? -complete=dir Buffers
      \ call fzf#vim#buffers(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang -nargs=? -complete=dir Windows
      \ call fzf#vim#windows(fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

if has('gui_running')
else
  nnoremap <space>of :OpenFiles<CR>
  " HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れて :Files を開く
  vnoremap <space>of :call ChangeToFileFormatAndCopyAndSearchFiles()<cr>
endif

nnoremap <space>ob :Buffers<CR>
" HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れて :Buffers を開く
vnoremap <space>ob :call ChangeToFileFormatAndCopyAndSearchBuffers()<cr>

nnoremap <space>ow :Windows<CR>

" 単語補完
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.3, 'height': 0.9, 'xoffset': 1 }})
" ファイル名補完
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files', {'window': { 'width': 0.3, 'height': 0.9, 'xoffset': 1 }})

" }}}

" ## LSP 設定 ---------------------- {{{

" ## neoclide/coc.nvim {{{

" nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" https://github.com/neoclide/coc-tsserver/issues/282#issuecomment-819364074
nmap <space>p <Plug>(coc-codeaction-cursor)

nmap <space>r <Plug>(coc-rename)

nmap <space>f :call Format()<cr>
command! Format :call Format()
function! Format()
  call CocAction('format')
endfunction

" 定義ジャンプするときにウィンドウの開き方を選択する
" https://zenn.dev/skanehira/articles/2021-12-12-vim-coc-nvim-jump-split
function! ChoseAction(actions) abort
  echo join(map(copy(a:actions), { _, v -> v.text }), ", ") .. ": "
  let result = getcharstr()
  let result = filter(a:actions, { _, v -> v.text =~# printf(".*\(%s\).*", result)})
  return len(result) ? result[0].value : ""
endfunction

        " \ {"text": "(s)plit", "value": "split"},
function! CocJumpAction() abort
  let actions = [
        \ {"text": "(e)dit", "value": "edit"},
        \ {"text": "(v)slit", "value": "vsplit"},
        \ {"text": "(t)ab", "value": "tabedit"},
        \ ]
  return ChoseAction(actions)
endfunction

nnoremap <silent> gd :<C-u>call CocActionAsync('jumpDefinition', CocJumpAction())<CR>

" }}}

" }}}

" ## tmux 用設定 ---------------------- {{{

" tmux の中で vim を開いているときに shift + 方向 キーを有効にする
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" }}}

" ## カスタムファンクション ---------------------- {{{

" ## Vim 系 ---------------------- {{{

if exists('*LoadVIMRC')
else
  command! LoadVIMRC call LoadVIMRC()
  function! LoadVIMRC()
    source $MYVIMRC
    :noh
  endfunction
endif

command! OpenVIMRC call OpenVIMRC()
function! OpenVIMRC()
  vsplit $MYVIMRC
  :noh
endfunction

command! -nargs=0 SwitchVimPlugin call SwitchVimPlugin()
function! SwitchVimPlugin()
  try
    call fzf#run(fzf#wrap({
          \ 'source': 'ls ~/.vim/plugged',
          \ 'sink':  function('s:switch_vim_plugin'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
          \ }))
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:switch_vim_plugin(dir)
  call DeleteBufsWithoutExistingWindows()
  call SaveSession()
  call DeleteBuffers()
  silent! execute 'cd ~/.vim/plugged/' . a:dir
endfunction

command! PlugGetLatestCommits :call PlugGetLatestCommits()
function! PlugGetLatestCommits()
  let command = '~/.vim/functions/plug_get_latest_commits.rb'
  silent! execute 'r!' . command
endfunction

" }}}

" ## 表示系 ---------------------- {{{

function! ToggleDisplayNumber()
  silent! execute 'set invnumber'
endfunction

" }}}

" ## ファイル操作 ---------------------- {{{

command! OpenFiles call OpenFiles()
function! OpenFiles()
  call fzf#run(fzf#vim#with_preview(fzf#wrap({
        \ 'source': 'rg --hidden --files --sortr modified | grep -v .git',
        \ 'sink*': function('s:open_files'),
        \ 'options': [
        \   '--prompt', 'Files> ',
        \   '--multi',
        \   '--expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x',
        \   '--bind=ctrl-i:toggle-down,ctrl-p:toggle-preview',
        \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
        \ ],
        \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
        \ })))
endfunction

command! -bang OpenAllFiles call OpenAllFiles()
function! OpenAllFiles()
  try
    call fzf#run(fzf#wrap({
          \ 'source': 'rg --hidden --files --no-ignore | grep -v .git',
          \ 'sink*': function('s:open_files'),
          \ 'options': [
          \   '--prompt', 'AllFiles> ',
          \   '--multi',
          \   '--expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x',
          \   '--bind=ctrl-i:toggle-down,ctrl-p:toggle-preview',
          \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
          \ ],
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 },
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
  endtry
endfunction
echohl None

function! s:open_files(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get(
        \ {
        \   'ctrl-e': 'edit ',
        \   'ctrl-v': 'vertical split ',
        \   'enter': 'tab drop '
        \ },
        \ a:lines[0], 'tab drop ')
  if a:lines[0] == 'ctrl-x'
    call s:open_quickfix_list(cmd, a:lines[1:])
  else
    for file in a:lines[1:]
      exec cmd . file
    endfor
  endif
endfunction

function! s:open_quickfix_list(cmd, list)
  execute a:cmd . ' ' . a:list[0]
  let files = []
  for file in a:list[0:]
    let files = add(files, file . ':1:1:1')
  endfor
  let file_list = map(files, 's:open_quickfix(v:val)')
  if len(file_list) > 1
    call setqflist(file_list)
    copen
    wincmd p
  endif
endfunction

function! s:open_files_via_rg(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get(
        \ {
        \   'ctrl-e': 'edit',
        \   'ctrl-v': 'vertical split',
        \   'enter': 'GotoOrOpen tab'
        \ },
        \ a:lines[0], 'GotoOrOpen tab')
  let list = map(a:lines[1:], 's:open_quickfix(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    if a:lines[0] == 'ctrl-x'
      call setqflist(list)
      copen
      wincmd p
    else
      for fi in list
        exec 'tab drop ' . fi.filename
      endfor
    endif
  endif
endfunction

function! s:open_selected_files_with_another_tab(files)
  let current_branch = s:get_current_branch()
  for file in a:files
    silent execute '$tabnew ' . file
    execute 'Gvdiff ' . g:selected_branch . '...' . current_branch
    SwapWindow
  endfor
  unlet g:selected_branch
endfunction

command! -nargs=0 CopyCurrentPath call CopyCurrentPath()
function! CopyCurrentPath()
  let @+=expand('%')
  echo "copied current path: " . expand('%')
endfunction

command! -nargs=0 CopyCurrentPathWithLineNumber call CopyCurrentPathWithLineNumber()
function! CopyCurrentPathWithLineNumber()
  let @+=expand('%') . ':' . line('.')
  echo 'copied current path: ' . expand('%') . ':' . line('.')
endfunction

command! -nargs=0 CopyAbsolutePath call CopyAbsolutePath()
function! CopyAbsolutePath()
  let @+=expand('%:p')
  echo "copied absolute path: " . expand('%:p')
endfunction

command! -nargs=0 CopyCurrentFile call CopyCurrentFile()
function! CopyCurrentFile()
  let filepath = expand("%")
  let filename = fnamemodify(filepath, ":t")
  let @+= filename
  echo "copied current file: " . filename
endfunction

command! OpenFilesFromClipboard call OpenFilesFromClipboard()
function! OpenFilesFromClipboard()
  let list=@+
  let files = split(list, "\n")
  for file in files
    silent! exec 'tab drop ' . file
  endfor
endfunction

command! OpenFilesQuickfixFromClipboard call OpenFilesQuickfixFromClipboard()
function! OpenFilesQuickfixFromClipboard()
  let list=@+
  let files = split(list, "\n")
  call s:open_quickfix_list('edit', files)
endfunction

nnoremap <space>ot :OpenTargetFile<CR>
command! OpenTargetFile call OpenTargetFile()
function! OpenTargetFile()
  let target_path=''
  let path=expand('%')
  if path =~ '^app/'
    if path =~ '^app/controllers/'
      let target_path=substitute(substitute(expand('%'), '^app/controllers/', 'spec/requests/', ''), '\v(.+)_controller.rb', '\1', '')
    else
      let target_path=substitute(substitute(expand('%'), '^app/', 'spec/', ''), '\v(.+).rb', '\1', '')
    endif
  elseif path =~ '^lib/'
    let target_path=substitute(substitute(expand('%'), '^lib/', 'spec/lib/', ''), '\v(.+).rb', '\1', '')
  elseif path =~ '^spec/'
    if path =~ '^spec/requests/'
      let target_path=substitute(substitute(expand('%'), '^spec/requests/', 'app/controllers/', ''), '\v(.+)\/.+_spec.rb', '\1', '')
    elseif path =~ '^spec/lib/'
      let target_path=substitute(substitute(expand('%'), '^spec/lib/', 'lib/', ''), '\v(.+)_spec.rb', '\1', '')
    else
      let target_path=substitute(substitute(expand('%'), '^spec/', 'app/', ''), '\v(.+)_spec.rb', '\1', '')
    endif
  endif
  if target_path == ''
    echom 'no target file'
    return
  endif
  call OpenFiles()
  call feedkeys(target_path)
endfunction

command! Reload call Reload()
function! Reload()
  silent! exec 'checktime'
  "call s:setTitle()
endfunction

command! QuitAll call QuitAll()
function! QuitAll()
  call DeleteBufsWithoutExistingWindows()
  call SaveSession()
  call DeleteBuffers()
  normal ZQ
endfunction

command! QuitAllWithoutSaveSession call QuitAllWithoutSaveSession()
function! QuitAllWithoutSaveSession()
  call DeleteBuffers()
  normal ZQ
endfunction

nnoremap <space>oh :History<CR>

" https://github.com/jesseleite/dotfiles/blob/c75ae5ebd0589361e1fe84a912f1580a9b1f9a15/vim/plugin-config/fzf.vim#L44-L86
command! -bang OpenHistoryFileInProject call fzf#run(fzf#wrap(s:preview(<bang>0, {
  \ 'source': s:file_history_from_directory(getcwd()),
  \ 'sink*': function('s:open_files'),
  \ 'options': [
  \   '--prompt', 'OpenHistoryFileInProject> ',
  \   '--multi',
  \   '--expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x',
  \   '--bind=ctrl-i:toggle-down,ctrl-p:toggle-preview',
  \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
  \ ]}), <bang>0))

function! s:file_history_from_directory(directory)
  return fzf#vim#_uniq(filter(fzf#vim#_recent_files(), "s:file_is_in_directory(fnamemodify(v:val, ':p'), a:directory)"))
endfunction

function! s:file_is_in_directory(file, directory)
  return filereadable(a:file) && match(a:file, a:directory . '/') == 0
endfunction

function! s:preview(bang, ...)
  let preview_window = get(g:, 'fzf_preview_window', a:bang && &columns >= 80 || &columns >= 120 ? 'right': '')
  if len(preview_window)
    return call('fzf#vim#with_preview', add(copy(a:000), preview_window))
  endif
  return {}
endfunction

" }}}

" ## タブ操作 ---------------------- {{{

function! MoveTabRight()
  silent! execute '+tabm'
endfunction

function! MoveTabLeft()
  silent! execute '-tabm'
endfunction

command! CopyAllTabPath call CopyAllTabPath()
function! CopyAllTabPath()
  let files = [expand('%')]
  let max = 20
  let index = 0
  while index < max
    sleep 50ms
    let index = index + 1
    silent! exec "normal gt"
    let file=expand('%')
    if file == files[0]
      break
    endif
    call add(files, file)
  endwhile
  let @+=join(files, "\n")
endfunction

command! CopyAllTabAbsolutePath call CopyAllTabAbsolutePath()
function! CopyAllTabAbsolutePath()
  let files = [expand('%:p')]
  let max = 20
  let index = 0
  while index < max
    sleep 50ms
    let index = index + 1
    silent! exec "normal gt"
    let file=expand('%:p')
    if file == files[0]
      break
    endif
    call add(files, file)
  endwhile
  let @+=join(files, "\n")
endfunction

function! s:actuality_tab_count()
  let ws = s:list_windows()
  let tab_count = 0
  let non_tab_count = 0
  for win in ws
    if win =~ '^.*\s\[No\-Name\]\s.*'
      let non_tab_count = non_tab_count + 1
    else
      let tab_count = tab_count + 1
    endif
  endfor
  return tab_count
endfunction

command! -bang CloseRightTab call CloseRightTab('<bang>')
function! CloseRightTab(bang)
  let cur=tabpagenr()
  while cur < tabpagenr('$')
    exe 'tabclose' . a:bang . ' ' . (cur + 1)
  endwhile
endfunction

command! -bang CloseLeftTab call CloseLeftTab('<bang>')
function! CloseLeftTab(bang)
  while tabpagenr() > 1
    exe 'tabclose' . a:bang . ' 1'
  endwhile
endfunction

command! -bang CloseTabs call CloseTabs('<bang>')
function! CloseTabs(bang)
  call CloseRightTab(a:bang)
  call CloseLeftTab(a:bang)
endfunction

command! MergeTab call MergeTab()
function! MergeTab()
  let bufnums = tabpagebuflist()
  hide tabclose
  topleft vsplit
  for n in bufnums
    execute 'vertical sb ' . n
    wincmd _
  endfor
  wincmd t
  quit
  wincmd =
endfunction

command! SeparateTab call SeparateTab()
function! SeparateTab()
  wincmd l
  let file=expand('%')
  exec 'close'
  exec 'tab drop ' . file
  normal gT
endfunction

" }}}

" ## セッション操作 ---------------------- {{{

command! SaveSession call SaveSession()
function! SaveSession()
  let current_dir = s:getCurrentDirectory()
  silent! execute 'mks! ~/.vim/sessions/' . current_dir
  echom 'saved current session : ' .current_dir
endfunction

command! -bang OpenSession call OpenSession()
function! OpenSession()
  call fzf#run(fzf#wrap({
        \ 'source': 'ls ~/.vim/sessions',
        \ 'options': [
        \   '--prompt', 'Session> ',
        \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
        \ ],
        \ 'sink':  function('s:load_session'),
        \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
        \ }))
endfunction

command! -bang SwitchSession call SwitchSession()
function! SwitchSession()
  try
    call fzf#run(fzf#wrap({
          \ 'source': 'ls ~/.vim/sessions',
          \ 'sink':  function('s:load_session'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:load_session(...)
  call DeleteBufsWithoutExistingWindows()
  call SaveSession()
  call DeleteBuffers()
  silent! execute 'source ~/.vim/sessions/' . a:1
  silent! execute 'source $MYVIMRC'
  "call s:setTitle()
endfunction

command! -bang DeleteSessions call DeleteSessions()
function! DeleteSessions()
  try
    call fzf#run(fzf#wrap({
          \ 'source': 'ls ~/.vim/sessions',
          \ 'options': '--multi --bind=ctrl-a:select-all,ctrl-i:toggle+down ',
          \ 'sink*':  function('s:delete_sessions'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:delete_sessions(sessions)
  for session in a:sessions
    call delete(expand('~/.vim/sessions/' . session))
  endfor
endfunction

" }}}

" ## ウィンドウ操作 ---------------------- {{{

command! SwapWindow call SwapWindow()
function! SwapWindow()
  silent! exec "normal \<c-w>\<c-r>"
endfunction

function! s:delete_windows(lines)
  execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[3]}))
endfunction

command! DeleteWindow call fzf#run(fzf#wrap({
      \ 'source': s:list_windows(),
      \ 'sink*': { lines -> s:delete_windows(lines) },
      \ 'options': '--multi --reverse --bind ctrl-a:select-all,ctrl-d:deselect-all'
      \ }))

" https://stackoverflow.com/questions/5927952/whats-the-implementation-of-vims-default-tabline-function
function! s:list_windows()
  let list = []
  let tabnumber = 1

  while tabnumber <= tabpagenr('$')
    let buflist = tabpagebuflist(tabnumber)
    let winnumber = 1
    for buf in buflist
      silent! let file = expandcmd('#'. buf .'<.rb')
      let file = substitute(file, '#.*', '[No-Name]', '')
      let line = tabnumber . ' ' . winnumber . ' ' . file . ' ' . buf
      call add(list, line)
      let winnumber = winnumber + 1
    endfor
    let tabnumber = tabnumber + 1
  endwhile

  return list
endfunction

" }}}

" ## タブ操作 ---------------------- {{{

command! CloseDupTabs :call CloseDuplicateTabs()
function! CloseDuplicateTabs()
  let cnt = 0
  let i = 1

  let tpbufflst = []
  let dups = []
  let tabpgbufflst = tabpagebuflist(i)
  while type(tabpagebuflist(i)) == 3
    if index(tpbufflst, tabpagebuflist(i)) >= 0
      call add(dups,i)
    else
      call add(tpbufflst, tabpagebuflist(i))
    endif

    let i += 1
    let cnt += 1
  endwhile

  call reverse(dups)

  for tb in dups
    exec "tabclose ".tb
  endfor

endfunction

" }}}

" ## バッファ操作 ---------------------- {{{

function! DeleteBufsWithoutExistingWindows()
  let allbufnums = ListAllBufNums()
  let bufnums = ListBufNums()
  for num in allbufnums
    if (index(bufnums, num) < 0)
      execute 'bwipeout! ' . num
      echom num . ' is deleted!'
    endif
  endfor
endfunction

command! DeleteBuffers call DeleteBuffers()
function! DeleteBuffers()
  let allbufnums = ListAllBufNums()
  for num in allbufnums
    execute 'bwipeout! ' . num
  endfor
endfunction

" https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! -bang DeleteBuffersByFZF call DeleteBuffersByFZF()
function! DeleteBuffersByFZF()
  try
    call fzf#run(fzf#wrap({
          \ 'source': s:list_buffers(),
          \ 'sink*': { lines -> s:delete_buffers(lines) },
          \ 'options': '--multi --reverse --bind ctrl-a:select-all'
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

" }}}

" ## レジスタ操作 ---------------------- {{{

" https://github.com/junegunn/fzf.vim/issues/647#issuecomment-520259307
function! s:get_registers() abort
  redir => l:regs
  silent registers
  redir END

  return split(l:regs, '\n')[1:]
endfunction

function! s:registers(...) abort
  try
    let l:opts = {
          \ 'source': s:get_registers(),
          \ 'sink': {x -> feedkeys(matchstr(x, '\v^\S+\ze.*') . (a:1 ? 'P' : 'p'), 'x')},
          \ 'options': '--prompt="Reg> "'
          \ }
    call fzf#run(fzf#wrap(l:opts))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

command! -bang Registers call s:registers('<bang>' ==# '!')

command! -bang StartCopyStatusMessages call s:start_copy_status_messages()
function! s:start_copy_status_messages() abort
  redir @+
endfunction
command! -bang FinishCopyStatusMessages call s:finish_copy_status_messages()
function! s:finish_copy_status_messages() abort
  redir END
endfunction

command! CopyStatusMessage call CopyStatusMessage()
function! CopyStatusMessage()
  try
    call fzf#run(fzf#wrap({
          \ 'source': s:get_status_messages(),
          \ 'sink':  function('s:copy_message'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:get_status_messages()
  let n = a:0 > 0 ? a:1 : 200
  let lines = filter(split(s:redir('messages'), "\n"), 'v:val !=# ""')
  if n > len(lines)
    let n = len(lines)
  endif
  let lines = lines[len(lines) - n :]
  return reverse(uniq(lines))
endfunction

function! s:copy_message(message)
  let @+ = a:message
endfunction

function! s:redir(cmd) abort
  let [verbose, verbosefile] = [&verbose, &verbosefile]
  set verbose=0 verbosefile=
  redir => str
    execute 'silent!' a:cmd
  redir END
  let [&verbose, &verbosefile] = [verbose, verbosefile]
  return str
endfunction

" }}}

" ## Diff ---------------------- {{{

command! DiffFile call DiffFile()
function! DiffFile()
  try
    call fzf#run(fzf#wrap({
          \ 'source': s:list_tabs(),
          \ 'sink':  function('s:diff_files'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:list_tabs()
  let list = []
  let tabnumber = 1

  while tabnumber <= tabpagenr('$')
    let buflist = tabpagebuflist(tabnumber)
    let winnumber = 1
    for buf in buflist
      silent! let file = expandcmd('#'. buf)
      let file = substitute(file, '#.*', '[No-Name]', '')
      let line = file
      call add(list, line)
      let winnumber = winnumber + 1
    endfor
    let tabnumber = tabnumber + 1
  endwhile

  return list
endfunction

function! s:diff_files(line)
  execute 'vertical diffsplit ' . a:line
  set wrap
  silent! exec "normal \<c-w>h"
  set wrap
endfunction

function! s:select_diff_files(branch)
  let current_branch = s:get_current_branch()
  let g:selected_branch = a:branch
  try
    call fzf#run(fzf#wrap({
          \ 'source':  printf('git diff' . a:branch . '...' . current_branch . ' --name-only'),
          \ 'options': '--multi --bind=ctrl-a:select-all,ctrl-i:toggle+down ',
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 },
          \ 'sink*': function('s:open_selected_files_with_another_tab')}))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

" }}}

" ## プロジェクト横断 ---------------------- {{{

nnoremap <space>op :call SwitchProject()<cr>
function! SwitchProject()
  call fzf#run(fzf#vim#with_preview(fzf#wrap({
        \ 'source': 'ghq list --full-path',
        \ 'sink':  function('s:open_project'),
        \ 'options': [
        \   '--prompt', 'Project> ',
        \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
        \ ],
        \ 'placeholder': '{}/README.md',
        \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
        \ })))
endfunction

function! s:open_project(project)
  call DeleteBufsWithoutExistingWindows()
  call SaveSession()
  call DeleteBuffers()
  silent! execute 'cd ' . a:project
  call s:setTitle()
endfunction

function! s:open_file_in_another_project(lines)
  unlet g:rg_in_another_project_file
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-e': 'edit ',
        \ 'ctrl-v': 'vertical split ',
        \ 'enter': 'tab drop '}, a:lines[0], 'e ')
  for file in a:lines[1:]
    exec cmd . split(file, ':')[0]
  endfor
endfunction

command! -nargs=0 OpenAnotherProjectFile call s:ghq_list_and_open_another_project_file()

function! s:ghq_list_and_open_another_project_file()
  try
    call fzf#run(fzf#wrap({
          \ 'source': 'ghq list --full-path',
          \ 'sink':  function('s:open_another_project_file'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:open_another_project_file(line)
  try
    call fzf#run(fzf#vim#with_preview(fzf#wrap({
          \ 'source':  printf('find ' . a:line . ' -not -path "' . a:line . '/.git/*" -not -path "' . a:line . '/vendor/*" -type f'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 },
          \ 'options': '--multi --bind=ctrl-p:toggle-preview --expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x ',
          \ 'sink*':   function('s:open_files')})))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

" }}}

" ## 検索 ---------------------- {{{

" https://github.com/junegunn/fzf/wiki/Examples-(vim)#narrow-ag-results-within-vim
" bind は selection を参考に。http://manpages.ubuntu.com/manpages/focal/man1/fzf.1.html
command! -nargs=* RG call fzf#run(fzf#vim#with_preview(fzf#wrap({
      \ 'source':  printf("rg --column --no-heading --color always --smart-case '%s'",
      \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
      \ 'sink*':    function('s:open_files_via_rg'),
      \ 'options': '--layout=reverse --ansi --expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x '.
      \            '--prompt="RG> " '.
      \            '--delimiter : --preview-window +{2}-/2 '.
      \            '--multi --bind=ctrl-a:select-all,ctrl-u:toggle,ctrl-p:toggle-preview '.
      \            '--color hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
      \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
      \ })))

command! -nargs=* RGFromAllFiles call fzf#run(fzf#vim#with_preview(fzf#wrap({
      \ 'source':  printf("rg --column --hidden --no-ignore --no-heading --color always --smart-case -g '!.git'  '%s'",
      \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
      \ 'sink*':    function('s:open_files_via_rg'),
      \ 'options': '--layout=reverse --ansi --expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x '.
      \            '--prompt="RGFromAllFiles> " '.
      \            '--delimiter : --preview-window +{2}-/2 '.
      \            '--multi --bind=ctrl-a:select-all,ctrl-u:toggle,ctrl-p:toggle-preview '.
      \            '--color hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
      \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
      \ })))

function! SearchByRG()
  if mode() == 'n'
    execute 'RG ' . input('RG/')
  else
    let selected = SelectedVisualModeText()
    let @+=selected
    echom 'Copyed! ' . selected
    execute 'RG ' . selected
    silent! exec "normal \<c-c>"
    if has('nvim')
      call feedkeys(' ')
    endif
  endif
endfunction

function! RGBySelectedText()
  let selected = SelectedVisualModeText()
  let @+=selected
  echom 'Copyed! ' . selected
  execute 'RG ' . selected
endfunction

command! RGFromAllFilesVisual call RGFromAllFilesVisual()
function! RGFromAllFilesVisual()
  let selected = SelectedVisualModeText()
  let @+=selected
  execute 'RGFromAllFiles ' . selected
  silent! exec "normal \<c-c>"
  if has('nvim')
    call feedkeys('i', 'n')
  endif
endfunction

command! RGFromAllFilesNormal call RGFromAllFilesNormal()
function! RGFromAllFilesNormal()
  execute 'RGFromAllFiles ' . input('RGFromAllFiles/')
  if has('nvim')
    call feedkeys('i', 'n')
  endif
endfunction

function! VimGrepBySelectedText()
  let selected = SelectedVisualModeText()
  let @+=selected
  echom 'Copyed! ' . selected
  execute 'vimgrep ' . input('vimgrep/') . " app/** lib/** config/** spec/** apidoc/**"
endfunction

command! RGInLocalNote call RGInLocalNote()
function! RGInLocalNote()
  execute 'RGInLocalNoteAndOpen ' . input('RGInLocalNote/')
  if has('nvim')
    call feedkeys('i', 'n')
  endif
endfunction

command! -nargs=* RGInLocalNoteAndOpen call fzf#run(fzf#vim#with_preview(fzf#wrap({
      \ 'source':  printf("rg '%s' $LOCAL_NOTE_ROOT --column --hidden --no-ignore --no-heading --color always --smart-case -g '!.git' ",
      \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
      \ 'sink*':    function('s:open_files_via_rg'),
      \ 'options': '--layout=reverse --ansi --expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x '.
      \            '--delimiter : --preview-window +{2}-/2 '.
      \            '--multi --bind=ctrl-u:toggle,ctrl-p:toggle-preview '.
      \            '--color hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
      \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
      \ })))

command! RGInCloudNote call RGInCloudNote()
function! RGInCloudNote()
  execute 'RGInCloudNoteAndOpen ' . input('RGInCloudNote/')
  if has('nvim')
    call feedkeys('i', 'n')
  endif
endfunction

command! -nargs=* RGInCloudNoteAndOpen call fzf#run(fzf#vim#with_preview(fzf#wrap({
      \ 'source':  printf("rg '%s' $CLOUD_NOTE_ROOT --column --hidden --no-ignore --no-heading --color always --smart-case -g '!.git' ",
      \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
      \ 'sink*':    function('s:open_files_via_rg'),
      \ 'options': '--layout=reverse --ansi --expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x '.
      \            '--delimiter : --preview-window +{2}-/2 '.
      \            '--multi --bind=ctrl-u:toggle,ctrl-p:toggle-preview '.
      \            '--color hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
      \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
      \ })))

command! -nargs=0 RGInAnotherProject call s:ghq_list_rg_in_another_project()

function! s:ghq_list_rg_in_another_project()
  try
    call fzf#run(fzf#wrap({
          \ 'source': 'ghq list --full-path',
          \ 'sink':  function('s:rg_in_another_project'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:rg_in_another_project(line)
  let g:rg_in_another_project_file = a:line
  execute 'RGOnAnotherProject ' . input('RGOnAnotherProject/')
  if has('nvim')
    call feedkeys('i', 'n')
  endif
endfunction

command! -nargs=* RGOnAnotherProject call fzf#run(fzf#vim#with_preview(fzf#wrap({
      \ 'source':  printf("rg '%s' " . g:rg_in_another_project_file . " --column --hidden --no-ignore --no-heading --color always --smart-case -g '!.git' -g '!vendor' ",
      \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
      \ 'sink*':    function('s:open_file_in_another_project'),
      \ 'options': '--layout=reverse --ansi --expect=ctrl-v,enter,ctrl-e '.
      \            '--delimiter : --preview-window +{2}-/2 '.
      \            '--multi --bind=ctrl-u:toggle,ctrl-p:toggle-preview '.
      \            '--color hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
      \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
      \ })))

" }}}

" ## カスタム置換 ---------------------- {{{

command! SnakeCase call SnakeCase()
function! SnakeCase() range
  let start_col = col('.')
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\l)(\u)/\1_\L\2\e/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\u)(\u)/\1_\L\2\e/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V::/\//g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\u)/\L\1\e/g'
  silent! exec 'normal ' . start_col . '|'
endfunction

command! PascalCase call PascalCase()
function! PascalCase() range
  let start_col = col('.')
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V<(\l)/\U\1\e/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V_([a-z])/\u\1/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\l)\/(\u)/\1::\2/g'
  silent! exec 'normal ' . start_col . '|'
endfunction

function! CapitalCaseToSnakeCase() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V([a-zA-Z])\s([a-zA-Z])/\1_\2/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\u)/\L\1\e/g'
endfunction

command! RemoveUnderBar call RemoveUnderBar()
function! RemoveUnderBar() range
  let start_col = col('.')
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V_/ /g'
  silent! exec 'normal ' . start_col . '|'
endfunction

command! AddUnderBar call AddUnderBar()
function! AddUnderBar() range
  let start_col = col('.')
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V\s/_/g'
  silent! exec 'normal ' . start_col . '|'
endfunction

function! RemoveBeginningOfLineSpace() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v^ *//g'
endfunction

command! ModuleToColon call ModuleToColon()
function! ModuleToColon() range
  silent! execute g:firstline . ',' . g:lastline . 's/\v%Vmodule (.+)\n/::\1/g'
  silent! execute g:firstline . ',' . g:lastline . 's/\v%Vclass (.+)\n/::\1/g'
  silent! execute g:firstline . ',' . g:lastline . 's/\v%V \< .*//g'
  silent! execute g:firstline . ',' . g:lastline . 's/\v%V\s//g'
  silent! execute g:firstline . ',' . g:lastline . 's/\v%V^:://g'
  silent! execute a:firstline . ',' . a:lastline . 's/^/class /g'
endfunction

command! ColonToModule call ColonToModule()
function! ColonToModule() range
  silent! execute g:firstline . ',' . g:lastline . 's/\v%Vclass /module /g'
  silent! execute g:firstline . ',' . g:lastline . 's/\v%V::/ module /g'
  silent! execute g:firstline . ',' . g:lastline . 's/\v%V module /\rmodule /g'
endfunction

command! CommaToBreakline call CommaToBreakline()
function! CommaToBreakline() range
  silent! execute g:firstline . ',' . g:lastline . 's/,/,\r/g'
endfunction

command! JsonToHash call JsonToHash()
function! JsonToHash() range
  silent! execute g:firstline . ',' . g:lastline . 's/\"\(\w*\)\"\(:.*\)/\1\2/g'
  silent! execute g:firstline . ',' . g:lastline . "s/\'/\\\\'/g"
  silent! execute g:firstline . ',' . g:lastline . 's/"' . "/'/g"
endfunction

command! HashToJson call HashToJson()
function! HashToJson() range
  silent! execute g:firstline . ',' . g:lastline . 's/\(\w*\)\:/\"\1\":/g'
  silent! execute g:firstline . ',' . g:lastline . "s/'" . '/"/g'
endfunction

command! RocketToHash call RocketToHash()
function! RocketToHash() range
  silent! execute g:firstline . ',' . g:lastline . 's/\v%V^(\s*)"(\w+)".*\=\>/\1\2:/g'
  silent! execute g:firstline . ',' . g:lastline . 's/\v%V^(\s*)(\w+):\s*/\1\2: /g'
  silent! execute g:firstline . ',' . g:lastline . "s/\\v'/\\\\'/g"
  silent! execute g:firstline . ',' . g:lastline . 's/"' . "/'/g"
endfunction

command! HashToRocket call HashToRocket()
function! HashToRocket() range
  silent! execute g:firstline . ',' . g:lastline . 's/\v^(\s+)(\w+):\s*/\1\2: /g'
  silent! execute g:firstline . ',' . g:lastline . 's/\v^(\s+)(\w+):/\1"\2" =>/g'
  silent! execute g:firstline . ',' . g:lastline . "s/\'/\"/g"
endfunction

" }}}

" ## ヘルパー ---------------------- {{{

function! s:setTitle()
  let dir = s:getCurrentDirectory()
  let branch = s:getCurrentBranch()
  silent! exec 'set titlestring=' . dir . '---' . branch
endfunction

function! s:getCurrentDirectory()
  redir => path
  silent pwd
  redir END
  let splited = split(path, '/')
  return splited[-1]
endfunction

function! s:getCurrentBranch()
  let inputfile = ".git/HEAD"
  let line = readfile(inputfile)[0]
  return substitute(line, "ref: refs/heads/", "", "g")
endfunction

function! SelectedVisualModeText()
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction

function! ChangeToFileFormat(text)
  let snake_case = substitute(substitute(a:text, '\(\l\)\(\u\)', '\1_\L\2\e', "g"), '\(\u\)\(\u\)', '\1_\L\2\e', "g")
  let down_case = tolower(snake_case)
  let file_format = substitute(down_case, '::', '/', "g")
  return file_format
endfunction

function! ChangeToFileFormatAndCopy()
  let selected_text = SelectedVisualModeText()
  let file_format = ChangeToFileFormat(selected_text)
  let @+=file_format
  echom 'Copyed! ' . file_format
endfunction

function! ChangeToFileFormatAndCopyAndSearchFiles()
  let selected_text = SelectedVisualModeText()
  let file_format = ChangeToFileFormat(selected_text)
  let @+=file_format
  echom 'Copyed! ' . file_format
  execute 'Files'
endfunction

function! ChangeToFileFormatAndCopyAndSearchBuffers()
  let selected_text = SelectedVisualModeText()
  let file_format = ChangeToFileFormat(selected_text)
  let @+=file_format
  echom 'Copyed! ' . file_format
  execute 'Buffers'
endfunction

function! ListBufNums()
  let list = []
  let tabnumber = 1

  while tabnumber <= tabpagenr('$')
    let buflist = tabpagebuflist(tabnumber)
    for buf in buflist
      call add(list, buf)
    endfor
    let tabnumber = tabnumber + 1
  endwhile

  return list
endfunction

function! ListAllBufNums()
  redir => bufs
  silent ls
  redir END
  let buflist = split(bufs, "\n")
  let listbufnums = []
  for buf in buflist
    let num = str2nr(substitute(buf, '^\s*\(\d*\)\s*.*', '\1', ''))
    call add(listbufnums, num)
  endfor
  return listbufnums
endfunction

function! ListTermBufNums()
  redir => bufs
  silent ls!('R')
  redir END
  let buflist = split(bufs, "\n")
  let listbufnums = []
  for buf in buflist
    let num = str2nr(substitute(buf, '^\s*\(\d*\)\s*.*', '\1', ''))
    call add(listbufnums, num)
  endfor
  return listbufnums
endfunction

nnoremap <space><space> :<c-u>call SelectFunction()<CR>
function! SelectFunction()
  let g:mode = 'n'
  execute 'SelectFunction'
endfunction

command! -nargs=0 SelectFunction call fzf#run(fzf#wrap({
      \ 'source': 'cat ~/.vim/functions/normal',
      \ 'sink':  function('s:select_function_handler'),
      \ 'options': [
      \   '--prompt', 'Function> ',
      \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
      \ ],
      \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
      \ }))

if exists('*s:select_function_handler')
else
  function! s:select_function_handler(line)
    execute a:line
    unlet g:mode
  endfunction
endif

vnoremap <space><space> :<c-u>call SelectVisualFunction()<CR>
function! SelectVisualFunction()
  let g:mode = 'v'
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let g:firstline = line_start
  let g:lastline = line_end
  execute 'SelectVidualFunction'
endfunction

command! -nargs=* SelectVidualFunction call fzf#run(fzf#wrap({
      \ 'source': 'cat ~/.vim/functions/visual',
      \ 'sink':  function('s:select_visual_function_handler'),
      \ 'options': [
      \   '--prompt', 'Function> ',
      \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
      \ ],
      \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
      \ }))

function! s:select_visual_function_handler(line) range
  execute a:line
  unlet g:mode
  unlet g:firstline
  unlet g:lastline
endfunction

function! s:open_quickfix(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2], 'text': join(parts[3:], ':')}
endfunction

" }}}

" ## Git ---------------------- {{{

command! LazyGit :call LazyGit()
function! LazyGit()
  if has('nvim')
    exec 'tabnew | term lazygit'
  else
    exec 'tab term ++close lazygit'
  endif
endfunction

command! OpenGitHubRepo :call OpenGitHubRepo()
function! OpenGitHubRepo()
  let command = '~/.vim/functions/open_github.rb'
  call asyncrun#run('', '', command)
endfunction

command! OpenGitHubFile :call OpenGitHubFile()
function! OpenGitHubFile()
  if g:mode == 'n'
    let line = a:firstline == a:lastline ? "#L" . line(".") : "#L" . a:firstline . "-L" . a:lastline
  else
    let line = g:firstline == g:lastline ? "#L" . line(".") : "#L" . g:firstline . "-L" . g:lastline
  endif
  let command = "~/.vim/functions/open_github.rb '" . expand("%:p") . "' '" . line . "'"
  call asyncrun#run('', '', command)
endfunction

command! OpenGitHubBlame :GBInteractive

command! CopyGitHubCompareUrl :call CopyGitHubCompareUrl()
function! CopyGitHubCompareUrl()
  let command = "~/.vim/functions/copy_github_compare_url.rb"
  call asyncrun#run('', '', command)
endfunction

command! -nargs=0 GitAdd call GitAdd()
function! GitAdd()
  AsyncStop
  sleep 50ms
  AsyncRun -silent git add .
  echom 'executed "git add ."'
endfunction

command! GitPush :call GitPush()
function! GitPush()
  AsyncStop
  sleep 50ms
  AsyncRun -silent git push
  echom 'executed "git push"'
endfunction

command! GitAddCommitPush :call GitAddCommitPush()
function! GitAddCommitPush()
  AsyncStop
  sleep 50ms
  let command = "~/.vim/functions/git_add_commit_push.rb"
  call asyncrun#run('', '', command)
endfunction

command! GitPull :call GitPull()
function! GitPull()
  AsyncStop
  sleep 50ms
  AsyncRun -silent git pull
  echom 'executed "git pull"'
endfunction

command! GitSelectBranch :call GitSelectBranch()
function! GitSelectBranch()
  try
    call fzf#run(fzf#wrap({
          \ 'source': 'ls .git/refs/heads',
          \ 'sink':  function('s:git_checkout'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 },
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:git_checkout(branch)
  silent! execute '!git checkout ' . a:branch
  call s:setTitle()
  Reload
  echom 'select branch to ' . a:branch
endfunction

command! -bang DiffFileGitBranch call DiffFileGitBranch()
function! DiffFileGitBranch()
  try
    call fzf#run(fzf#wrap({
          \ 'source': 'git --no-pager branch | sed "/* /d"',
          \ 'sink': function('s:select_diff_files'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 },
          \ }))
    if has('nvim')
      call feedkeys('i', 'n')
    endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:get_current_branch()
  return substitute(FugitiveStatusline(), '^\[Git(\(.*\))\]', '\1', '')
endfunction

" }}}

" ## Util ---------------------- {{{

command! ExecInstall :call ExecInstall()
function! ExecInstall()
  AsyncStop
  sleep 50ms
  let command = "./install.sh"
  call asyncrun#run('', '', command)
  echom 'executed "./install.sh"'
endfunction

" }}}

" ## 履歴 ---------------------- {{{

nnoremap <space>or :History:<cr>
command! -bang CommandHistory call CommandHistory()
function! CommandHistory()
  try
    execute 'History:'
    call feedkeys('i', 'n')
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

" }}}

" ## ノート ---------------------- {{{
"
command! -bang SwitchNote call SwitchNote()
function! SwitchNote()
  call fzf#run(fzf#wrap({
        \ 'source': 'cat ~/.vim/functions/notes',
        \ 'sink':  function('s:switch_note'),
        \ 'options': [
        \   '--prompt', 'Note> ',
        \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
        \ ],
        \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
        \ }))
endfunction

function! s:switch_note(note)
  call DeleteBufsWithoutExistingWindows()
  call SaveSession()
  call DeleteBuffers()
  silent! execute 'cd $' . a:note
endfunction

nnoremap <space>on :call OpenLocalNote()<cr>
command! OpenLocalNote call OpenLocalNote()
function! OpenLocalNote()
  try
    call fzf#run(fzf#vim#with_preview(fzf#wrap({
          \ 'source': 'find $LOCAL_NOTE_ROOT -type file | sort',
          \ 'options': [
          \   '--prompt', 'Note> ',
          \   '--multi',
          \   '--expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x',
          \   '--bind=ctrl-i:toggle-down,ctrl-p:toggle-preview',
          \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
          \ ],
          \ 'sink*':   function('s:open_files'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
          \ })))
    " if has('nvim')
    "   call feedkeys('i', 'n')
    " endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

command! OpenCloudNote call OpenCloudNote()
function! OpenCloudNote()
  try
    call fzf#run(fzf#vim#with_preview(fzf#wrap({
          \ 'source': 'find $CLOUD_NOTE_ROOT -type file | sort',
          \ 'options': [
          \   '--prompt', 'Note> ',
          \   '--multi',
          \   '--expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x',
          \   '--bind=ctrl-i:toggle-down,ctrl-p:toggle-preview',
          \   '--color', 'hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
          \ ],
          \ 'sink*':   function('s:open_files'),
          \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
          \ })))
    " if has('nvim')
    "   call feedkeys('i', 'n')
    " endif
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

" }}}

" ## 実行 ---------------------- {{{

nnoremap <leader>r :RunExec<cr>
command! -nargs=0 RunExec call RunExec()
function! RunExec() abort
  let currentfile=expand('%')
  let type=&filetype
  let types = [ 'ruby', 'javascript', 'typescript' ]
  if (index(types, type) < 0)
    echohl WarningMsg | echon 'Can not run!! Available filetype are only ' | echohl ErrorMsg | echon join(types, ',') | echohl None
    return
  endif
  execute 'botright new'
  let cmd=''
  if type == 'ruby'
    if IsRailsProject() == 1
      let cmd=cmd . 'rails runner ' . currentfile
    else
      let cmd=cmd . 'ruby ' . currentfile
    endif
  elseif type == 'javascript'
    let cmd=cmd . 'node ' . currentfile
  elseif type == 'typescript'
    let cmd=cmd . 'npx ts-node ' . currentfile
  endif
  let cmd=DockerTransformer(cmd)
  call termopen(cmd)
  startinsert
endfunction

function! IsRailsProject() abort
  let is_rails = system("grep 'rails' 'Gemfile' >/dev/null && echo $status")
  let is_rails = substitute(is_rails, "\n", "", "")
  if is_rails == '0'
    return 1
  else
    return 0
  endif
endfunction

nnoremap <leader>d :RunDebug<cr>
command! -nargs=0 RunDebug call RunDebug()
function! RunDebug() abort
  let currentfile=expand('%')
  let type=&filetype
  let types = [ 'javascript' ]
  if (index(types, type) < 0)
    echohl WarningMsg | echon 'Can not run with debug mode!! Available filetype are only ' | echohl ErrorMsg | echon join(types, ',') | echohl None
    return
  endif
  execute 'botright new'
  let cmd=''
  if type == 'javascript'
    let cmd=cmd . 'node inspect ' . currentfile
  endif
  let cmd=DockerTransformer(cmd)
  call termopen(cmd)
  startinsert
endfunction

" }}}

" }}}

" ## for test lines ---------------------- {{{



" }}}
