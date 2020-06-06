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
set cmdheight=2

" コマンドをステータス行に表示
set showcmd

" モードを表示する
set showmode

" 画面のカラースキーマCygwinでみやすい色使い
" colorscheme  tortetorte

" アンダーライン
set cursorline

" ウィンドウ間のバーをカスタマイズ
set fillchars+=vert:\|
hi VertSplit ctermbg=238 ctermfg=238 guibg=#d0d0d0 guifg=#444444

" ステータスバーカラーをカスタマイズ
hi StatusLine ctermbg=Black ctermfg=Cyan
hi StatusLineNC ctermbg=252 ctermfg=238 guibg=#d0d0d0 guifg=#444444
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

" シンタックスエラーを下線にする
hi clear SpellBad
hi SpellBad cterm=underline
hi SpellCap cterm=underline
hi SpellRare cterm=underline
hi SpellLocal cterm=underline

" }}}

" ## 検索の挙動に関する設定 ---------------------- {{{

" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase

" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

" インクリメンタルサーチ
set incsearch

" 検索ハイライト
set hlsearch

" }}}

" ## カーソル移動に関する設定 ---------------------- {{{

" スクロールオフ
set scrolloff=10

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

" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

" タイポチェック
set spell spelllang=en_us
set nospell

" バッファ切り替え時のワーニングを無視
set hidden

" 保存時に行末空白削除
autocmd BufWritePre * :%s/\s\+$//ge

" }}}

" ファイル操作に関する設定 ---------------------- {{{

" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set nobackup

" スワップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set noswapfile

" }}}

" ## ツリー表示に関する設定 ---------------------- {{{

"ツリー表示
"表示を変更したい場合は i で切替可能
let g:netrw_liststyle=3
"上部のバナーを非表示
" I で toggle 可能
let g:netrw_banner = 0
"window サイズ
let g:netrw_winsize = 25
"Netrw で Enter 押下時の挙動設定
let g:netrw_browse_split = 4
let g:netrw_alto = 1

"Netrw を toggle する関数を設定
"元処理と異なり Vex を呼び出すことで左 window に表示
let g:NetrwIsOpen=0
function! ToggleNetrw()
  if g:NetrwIsOpen
    let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Vex
    endif
endfunction

" ショートカットの設定
" = を 2 回連続押下で toggle
noremap <silent>== :call ToggleNetrw()<CR>

" }}}

" ## カスタムマッピング ---------------------- {{{

" リーダーキーをスペースキーにする
let mapleader = " "

" ローカルリーダーキー を \ にする
let maplocalleader = "\\"

" インサートモードからエスケープ
inoremap <C-c> <esc>
" ウィンドウ間移動が遅くなるので以下は却下
" :inoremap jk <esc>
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

" ビジュアルモードで選択した範囲をクリップボードにコピー
vnoremap y "+y
" ビジュアルモードで選択した範囲にクリップボードからペースト
vnoremap p "+p
" ビジュアルモードで選択した範囲をカットしてクリップボードにコピー　
vnoremap d "+d
" ビジュアルモードで選択した範囲をカットしてクリップボードにコピー　
vnoremap x "+x

" https://superuser.com/questions/271471/vim-macro-to-convert-camelcase-to-lowercase-with-underscores
" キャメルケースをスネークケースに変換
vnoremap <leader>s :s/\<\@!\([A-Z]\)/\_\l\1/g<CR>gul
" スネークケースをキャメルケースに変換
vnoremap <leader>c :s/_\([a-z]\)/\u\1/g<CR>gUl
" 行頭の空白を削除
vnoremap <leader>= :s/\v^ *//g<CR>
" `class` と `::` を `module` にする置換
vnoremap <leader>: :s/\v(class \|\:\:)+/\rmodule /g<CR>

" ウインドウ間移動
nnoremap <leader>h <c-w>h
nnoremap <leader>j <c-w>j
nnoremap <leader>k <c-w>k
nnoremap <leader>l <c-w>l

" 画面分割
nnoremap <leader>v :vs<CR><c-w>l
nnoremap <leader>n :sp<CR><c-w>j

" ウインドウ幅を右に広げる
nnoremap <leader>. <c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>>
" ウインドウ幅を左に広げる
nnoremap <leader>, <c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><
" ウインドウ高さを高くする
nnoremap <leader>= <c-w>+<c-w><<c-w>+<c-w>+<c-w>+
" ウインドウ高さを低くする
nnoremap <leader>- <c-w>-<c-w>-<c-w>-<c-w>-<c-w>-

" 選択した両側を指定した記号で囲む　
vnoremap ' c'<C-r>"'<Esc>b
vnoremap " c"<C-r>""<Esc>b
vnoremap ` c`<C-r>"`<Esc>b
vnoremap ( c(<C-r>")<Esc>b
vnoremap ) c(<C-r>")<Esc>b
vnoremap [ c[<C-r>"]<Esc>b
vnoremap ] c[<C-r>"]<Esc>b
vnoremap { c{<C-r>"}<Esc>b
vnoremap } c{<C-r>"}<Esc>b
vnoremap < c<<C-r>"><Esc>b
vnoremap > c<<C-r>"><Esc>b
vnoremap * c*<C-r>"*<Esc>b
vnoremap ~ c~<C-r>"~<Esc>b
vnoremap <leader><space> c <C-r>" <Esc>b
" 選択した両側を一文字ずつ削除
vnoremap <leader>' c<Bs><C-r>"<Esc>wxb

" ~/.vimrc を開く
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" ~/.vimrc を読み込む
nnoremap <leader>sv :source $MYVIMRC<cr>

" 開いているファイルパスをコピーする
" https://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
" http://intothelambda.com/archives/4
nnoremap <leader>C :<C-u>echo "copied full path: " . expand('%:p') \| let @+=expand('%:p')<CR>
nnoremap <leader>c :<C-u>echo "copied current path: " . expand('%') \| let @+=expand('%')<CR>

" 方向キーとバックスペースキーを無効にする
vnoremap <Up>    <nop>
vnoremap <Down>  <nop>
vnoremap <Left>  <nop>
vnoremap <Right> <nop>
inoremap <Up>    <nop>
inoremap <Down>  <nop>
inoremap <Left>  <nop>
inoremap <Right> <nop>
nnoremap <Up>    <nop>
nnoremap <Down>  <nop>
nnoremap <Left>  <nop>
nnoremap <Right> <nop>
vnoremap <Bs>    <nop>
inoremap <Bs>    <nop>
nnoremap <Bs>    <nop>

" fzf キーバインド
nnoremap <silent> F :Files<CR>
nnoremap <silent> B :Buffers<CR>
nnoremap <silent> H :History<CR>
nnoremap <leader>/ :execute 'Rg ' . input('Rg/')<CR>

" スペースを 2 つ開けて `*` を入力して開始
nnoremap <leader>2 i<space><space>*<space>
" スペースを 4 つ開けて `*` を入力して開始
nnoremap <leader>4 i<space><space><space><space>*<space>

" }}}

" ## スニペット設定 ---------------------- {{{

" Ruby 用スニペット
iabbrev fro # frozen_string_literal: true
iabbrev par # @param options [String] description
iabbrev ret # @return [String] description
iabbrev rai # @raise [StandardError] description
iabbrev att attr_reader

" }}}

" ## カスタムコマンド ---------------------- {{{

command! -range=% JsonToHash :<line1>,<line2>call JsonToHash()
command! -range=% RocketToHash :<line1>,<line2>call RocketToHash()
command! BreakLine %s/\v}\s*,/},\r/ge | %s/\v]\s*,/],\r/ge | %s/\v"\s*,/",\r/ge | %s/{/{\r/ge | %s/}/\r}/ge | %s/\[/\[\r/ge | %s/\]/\r]/ge

" Rg でカラー出力しない
" https://github.com/junegunn/fzf.vim/issues/488#issuecomment-350523157
" https://github.com/junegunn/fzf.vim/pull/696
command! -bang -nargs=* Rg call fzf#vim#grep('rg --color never --column --line-number --no-heading --no-require-git '.shellescape(<q-args>), 1, <bang>0)

" }}}

" ## カスタムファンクション ---------------------- {{{

function! JsonToHash() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v^(\s*)"(\w+)"\s*:\s*/\1\2: /g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v^(\s*)"(\w+)"\s+:/\1\2:/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v^(\s*)"(\w+)":/\1\2:/g'
  silent! execute a:firstline . ',' . a:lastline . "s/'/\\'/g"
  silent! execute a:firstline . ',' . a:lastline . 's/"' . "/'/g"
  normal! gg=G
endfunction

function! RocketToHash() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v^(\s*)"(\w+)".*\=\>/\1\2:/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v^(\s*)(\w+):\s*/\1\2: /g'
  silent! execute a:firstline . ',' . a:lastline . "s/'/\\'/g"
  silent! execute a:firstline . ',' . a:lastline . 's/"' . "/'/g"
  normal! gg=G
endfunction

" }}}

" ## プラグイン設定 ---------------------- {{{

" プラグラインインストールコマンド `:PlugUpdate`
call plug#begin('~/.vim/plugged')
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-goimports'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

" }}}
