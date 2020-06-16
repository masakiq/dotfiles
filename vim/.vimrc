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
hi VertSplit ctermbg=240 ctermfg=240 guibg=#d0d0d0 guifg=#444444

" ステータスバーカラーをカスタマイズ
hi StatusLine ctermbg=Black ctermfg=Cyan
hi StatusLineNC ctermbg=252 ctermfg=240 guibg=#d0d0d0 guifg=#444444
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
autocmd BufWritePre * if &filetype != 'markdown' | :%s/\s\+$//ge | endif

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

" ## Markdown 設定 ---------------------- {{{

autocmd BufRead,BufNewFile *.mkd  set filetype=markdown
autocmd BufRead,BufNewFile *.md  set filetype=markdown
" Need: kannokanno/previm
nnoremap <space>m :PrevimOpen<CR>
" 自動で折りたたまないようにする
let g:vim_markdown_folding_disabled=1
let g:previm_enable_realtime = 1

" }}}

" ## カスタムマッピング ---------------------- {{{

" ### マップ基本設定 ---------------------- {{{

" リーダーキーを , にする
let mapleader = ","

" ローカルリーダーキーを , にする
" let maplocalleader = ","

" リーダーキーのディレイタイム
set timeout timeoutlen=800 ttimeoutlen=100

inoremap jk <esc>
inoremap <C-c> <esc>
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
inoremap <Bs>    <nop>
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

nnoremap V 0v$h

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

" }}}

" ### 変換系 ---------------------- {{{

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
vnoremap <leader>d c<Bs><C-r>"<Esc>wxb

" HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga に変換
vnoremap <leader>s :s/\v%V(\l)(\u)/\1_\L\2\e/ge<CR> \| :s/\v%V(\u)(\u)/\1_\L\2\e/ge<CR> \| :s/\v%V::/\//ge<CR> \| :s/\v%V(\u)/\L\1\e/ge<CR> \| :noh<CR>w
" hoge_hoge/fuga_fuga の形式を HogeHoge::FugaFuga に変換
vnoremap <leader>c :s/\v%V_([a-z])/\u\1/ge<CR> \| :s/\v%V\/(\l)/::\U\1\e/ge<CR> \| :s/\v%V<(\l)/\U\1\e/ge<CR> \| :noh<CR>w

" An Hoge fuga を a_hoge_fuga に変換
vnoremap <leader>_ :s/\v%V([a-zA-Z])\s([a-zA-Z])/\1_\2/ge<CR> \| :s/\v%V(\u)/\L\1\e/ge<CR> \| :noh<CR>w

" 行頭の空白を削除
vnoremap <leader>= :s/\v^ *//g<CR> \| :noh<CR>

" `class` と `::` を `module` にする置換
" vnoremap M :s/\v%V(class \|\:\:)+/\rmodule /g \| :noh<CR>
vnoremap <leader>m :s/\v%Vclass /module /ge<CR> \| :s/\v%V::/ module /ge<CR> \| :s/\v%V module /\rmodule /ge<CR> \| :noh<CR>

" 改行
vnoremap <leader>b :s/\v%V,/,\r/ge<cr> \| :normal! gg=G<CR> \| :noh<CR>

" JSON から Hash に変換
" vnoremap <leader>j :s/\v%V^(\s*)"(\w+)"\s*:\s*/\1\2: /ge<CR> \| :s/\v%V^(\s*)"(\w+)"\s+:/\1\2:/ge<CR> \| :s/\v%V^(\s*)"(\w+)":/\1\2:/ge<CR> \| :s/%V'/\\'/ge<CR> \| :s/%V\"/\'/ge<CR> \| :normal! gg=G<CR> \| :noh<CR>
vnoremap <leader>j :call JsonToHash()<cr>

" スペースを 2 つ開けて `*` を入力して開始
" nnoremap <leader>2 i<space><space>*<space>
" スペースを 4 つ開けて `*` を入力して開始
" nnoremap <leader>4 i<space><space><space><space>*<space>

" }}}

" ### ファイル操作系 ---------------------- {{{

" 開いているファイルの名前を変更する
nnoremap N :call RenameFile()<cr>

" 開いているファイルのパスをコピーする
" https://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
" http://intothelambda.com/archives/4
nnoremap <space>P :<C-u>echo "copied full path: " . expand('%:p') \| let @+=expand('%:p')<CR>
nnoremap <space>p :<C-u>echo "copied current path: " . expand('%') \| let @+=expand('%')<CR>

if has('nvim')
  " ~/.vimrc を開く
  nnoremap <space>ev :vsplit ~/.config/nvim/init.vim<cr>
  " ~/.vimrc を読み込む
  nnoremap <space>rv :source ~/.config/nvim/init.vim \| :noh<CR>
else
  " ~/.vimrc を開く
  nnoremap <space>ev :vsplit $MYVIMRC<cr>
  " ~/.vimrc を読み込む
  nnoremap <space>rv :source $MYVIMRC \| :noh<CR>
endif

" }}}

" ### ウィンドウ操作系 ---------------------- {{{

" ウインドウ間移動
nnoremap <space>h <c-w>h
nnoremap <space>j <c-w>j
nnoremap <space>k <c-w>k
nnoremap <space>l <c-w>l

" ウィンドウスワップ
nnoremap <space>r <c-w><c-r>

" 画面分割
nnoremap <space>v :vs<CR><c-w>l
nnoremap <space>s :sp<CR><c-w>j

" For Rails
" 実装ファイルからテストファイルを開く
nnoremap <space>t :execute ':vs ' . substitute(substitute(expand('%'), '^app', 'spec', ''), '\v(.+).rb', '\1_spec.rb', '')<CR><c-w>l
" テストファイルから実装ファイルを開く
nnoremap <space>i :execute ':vs ' . substitute(substitute(expand('%'), '^spec', 'app', ''), '\v(.+)_spec.rb', '\1.rb', '')<CR><c-w>l

" ウインドウ幅を右に広げる
nnoremap <space>. <c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>><c-w>>
" ウインドウ幅を左に広げる
nnoremap <space>, <c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><<c-w><
" ウインドウ高さを高くする
nnoremap <space>= <c-w>+<c-w>+<c-w>+<c-w>+<c-w>+<c-w>+<c-w>+<c-w>+<c-w>+<c-w>+<c-w>+
" ウインドウ高さを低くする
nnoremap <space>- <c-w>-<c-w>-<c-w>-<c-w>-<c-w>-<c-w>-<c-w>-<c-w>-<c-w>-<c-w>-<c-w>-

nnoremap <space>f :Files<CR>
" HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れて :Files を開く
vnoremap <space>f :call ChangeToFileFormatAndCopyAndSearchFiles()<cr>w

nnoremap <space>b :Buffers<CR>
" HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れて :Buffers を開く
vnoremap <space>b :call ChangeToFileFormatAndCopyAndSearchBuffers()<cr>w

" 前のバッファに戻る
nnoremap <space><left> :bprevious<CR>
" 次のバッファに進む
nnoremap <space><right> :bnext<CR>

nnoremap <silent> H :History<CR>

" HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れて :History を開く
vnoremap <space>h :call ChangeToFileFormatAndCopyAndSearchHistory()<cr>w

nnoremap <space>/ :execute 'Rg ' . input('Rg/')<CR>
vnoremap <space>/ :<C-u>call RgBySelectedText()<CR>

" }}}

" ### ターミナルモード ---------------------- {{{

" nnoremap <space>c :terminal<CR>

if has('nvim')
  tnoremap jf <C-\><C-n>
else
  tnoremap jf <C-w>N
endif

nnoremap <space>c :execute 'Buffers fish'<CR>

" }}}

" }}}

" ## スニペット設定 ---------------------- {{{

" Ruby 用スニペット
iabbrev fro # frozen_string_literal: true
" iabbrev par @param options [String] description
" iabbrev ret @return [String] description
" iabbrev rai @raise [StandardError] description
" iabbrev opt @option options [String] description
" iabbrev exa @example description
" iabbrev yie @yield [String] description
iabbrev att attr_reader
iabbrev yar # @param options [String] description <CR>@return [String] description<CR>@raise [StandardError] description<CR>@option options [String] description<CR>@example description<CR>@yield [String] description

" }}}

" ## カスタムコマンド ---------------------- {{{

command! -range=% JsonToHash :<line1>,<line2>call JsonToHash()
command! -range=% RocketToHash :<line1>,<line2>call RocketToHash()
command! BreakLine %s/\v}\s*,/},\r/ge | %s/\v]\s*,/],\r/ge | %s/\v"\s*,/",\r/ge | %s/{/{\r/ge | %s/}/\r}/ge | %s/\[/\[\r/ge | %s/\]/\r]/ge

" Rg でカラー出力しない
" https://github.com/junegunn/fzf.vim/issues/488#issuecomment-350523157
" https://github.com/junegunn/fzf.vim/pull/696
" command! -bang -nargs=* Rg call fzf#vim#grep('rg --color never --column --line-number --no-heading --no-require-git '.shellescape(<q-args>), 1, <bang>0)
" デフォルト rg --column --line-number --no-heading --color=always --smart-case --
" command! -bang -nargs=* Rg call fzf#vim#grep('rg --color never --column --line-number --no-heading --smart-case -- '.shellescape(<q-args>), 1, <bang>0)

" }}}

" ## カスタムファンクション ---------------------- {{{

function! JsonToHash() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V^(\s*)"(\w+)"\s*:\s*/\1\2: /g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V^(\s*)"(\w+)"\s+:/\1\2:/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V^(\s*)"(\w+)":/\1\2:/g'
  silent! execute a:firstline . ',' . a:lastline . "s/\\v'/\\\\'/g"
  silent! execute a:firstline . ',' . a:lastline . 's/"' . "/'/g"
  normal! gg=G
endfunction

function! RocketToHash() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V^(\s*)"(\w+)".*\=\>/\1\2:/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V^(\s*)(\w+):\s*/\1\2: /g'
  silent! execute a:firstline . ',' . a:lastline . "s/\\v'/\\\\'/g"
  silent! execute a:firstline . ',' . a:lastline . 's/"' . "/'/g"
  normal! gg=G
endfunction

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
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

function! ChangeToFileFormatAndCopyAndSearchHistory()
  let selected_text = SelectedVisualModeText()
  let file_format = ChangeToFileFormat(selected_text)
  let @+=file_format
  echom 'Copyed! ' . file_format
  execute 'History'
endfunction

function! RgBySelectedText()
  let selected = SelectedVisualModeText()
  let @+=selected
  echom 'Copyed! ' . selected
  execute 'Rg ' . selected
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
" For markdown
Plug 'tpope/vim-markdown'
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'
call plug#end()

" }}}
