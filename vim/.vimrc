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

" autocmd TerminalOpen * set nonu

" ファイルを読み込み
set autoread

" タブ表示カスタム
let g:airline_theme='cool'
" https://vi.stackexchange.com/questions/5622/how-do-i-configure-the-vim-airline-plugin-to-look-like-its-own-project-screensho
let g:airline_powerline_fonts = 1
" set t_Co=256
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#formatter = 'unique_tail'

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
autocmd FileType qf 13wincmd_

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
noremap <space>oe :call ToggleNetrw()<CR>

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
vnoremap <C-c> <esc>
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

vnoremap a <esc>G$vgg

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

" HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れる
vnoremap fy :call ChangeToFileFormatAndCopy()<cr>w

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
vnoremap $ g$

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
vnoremap <space> c<space><C-r>" <Esc>b
" 選択した両側を一文字ずつ削除
vnoremap <bs> c<Bs><C-r>"<Esc>wxb

" }}}

" ### ファイル操作系 ---------------------- {{{

nnoremap <space>q :q!<cr>

" 開いているウィンドウ以外のバッファを削除
" nnoremap <space>D :call DeleteBufsWithoutExistingWindows()<cr>

" }}}

" ### ウィンドウ操作系 ---------------------- {{{

" ウインドウ間移動
nnoremap <space>h <c-w>h
nnoremap <space>j <c-w>j
nnoremap <space>k <c-w>k
nnoremap <space>l <c-w>l

" 画面分割
nnoremap <space>sv :vs<CR><c-w>l
nnoremap <space>sh :sp<CR><c-w>j
" nnoremap <space>sx :sp<cr>:vs<cr><c-w>k:vs<cr><c-w>h15<c-w>+

" ウインドウ幅を右に広げる
nnoremap <space><right> 41<c-w>>
" ウインドウ幅を左に広げる
nnoremap <space><left> 41<c-w><
" ウインドウ高さを高くする
nnoremap <space><down> 9<c-w>+
" ウインドウ高さを低くする
nnoremap <space><up> 9<c-w>-

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
  " 右のタブに移動
  nnoremap ' :normal gt<CR>
  " 左のタブに移動
  nnoremap ; :normal gT<CR>

  " 現タブを左に移動
  nnoremap <space>m; :-tabm<CR>
  " 現タブを右に移動
  nnoremap <space>m' :+tabm<CR>
endif

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

" command! -range=% JsonToHash :<line1>,<line2>call JsonToHash()
" command! -range=% RocketToHash :<line1>,<line2>call RocketToHash()
" command! BreakLine %s/\v}\s*,/},\r/ge | %s/\v]\s*,/],\r/ge | %s/\v"\s*,/",\r/ge | %s/{/{\r/ge | %s/}/\r}/ge | %s/\[/\[\r/ge | %s/\]/\r]/ge

" }}}

" ## カスタムファンクション ---------------------- {{{

command! -nargs=0 CopyCurrentPath call CopyCurrentPath()
function! CopyCurrentPath()
  echo "copied current path: " . expand('%')
  let @+=expand('%')
endfunction

command! -nargs=0 CopyAbsolutePath call CopyAbsolutePath()
function! CopyAbsolutePath()
  echo "copied absolute path: " . expand('%:p')
  let @+=expand('%:p')
endfunction

command! -nargs=0 GitAdd call GitAdd()
function! GitAdd()
  echo system('git add .')
  echom 'executed "git add ."'
endfunction

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

command! OpenGitHub call OpenGitHub()
function! OpenGitHub()
  GHInteractive
endfunction

command! OpenGitHubBlame call OpenGitHubBlame()
function! OpenGitHubBlame()
  GBInteractive
endfunction

command! OpenImplementationFile call OpenImplementationFile()
function! OpenImplementationFile()
  execute ':vs ' . substitute(substitute(expand('%'), '^spec', 'app', ''), '\v(.+)_spec.rb', '\1.rb', '')
endfunction

command! OpenTestFile call OpenTestFile()
function! OpenTestFile()
  execute ':vs ' . substitute(substitute(expand('%'), '^app', 'spec', ''), '\v(.+).rb', '\1_spec.rb', '')
endfunction

command! SwapWindow call SwapWindow()
function! SwapWindow()
  silent! exec "normal \<c-w>\<c-r>"
endfunction

function! MoveTabRight()
  silent! execute '+tabm'
endfunction

function! MoveTabLeft()
  silent! execute '-tabm'
endfunction

command! SaveSession call SaveSession()
function! SaveSession()
  if s:actuality_tab_count() == 0
    return
  endif
  let current_dir = s:getCurrentDirectory()
  silent! execute 'mks! ~/.vim/sessions/' . current_dir
  echom 'saved current session : ' .current_dir
endfunction

function! s:getCurrentDirectory()
  redir => path
  silent pwd
  redir END
  let splited = split(path, '/')
  return splited[-1]
endfunction

command! CreateFloaterm call CreateFloaterm()
function! CreateFloaterm()
  let current_dir = s:getCurrentDirectory()
  execute 'FloatermNew --title=' . current_dir . '($1/$2) ' . '--name=' . current_dir
endfunction

function! ToSnakeCase() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\l)(\u)/\1_\L\2\e/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\u)(\u)/\1_\L\2\e/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V::/\//g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\u)/\L\1\e/g'
endfunction

function! ToPascalCase() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V<(\l)/\U\1\e/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V_([a-z])/\u\1/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\l)\/(\u)/\1::\2/g'
endfunction

function! CapitalCaseToSnakeCase() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V([a-zA-Z])\s([a-zA-Z])/\1_\2/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V(\u)/\L\1\e/g'
endfunction

function! RemoveUnderBar() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V_/ /g'
endfunction

function! RemoveBeginningOfLineSpace() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v^ *//g'
endfunction

function! ClassAndModuleToColon() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%Vmodule (.+)\n/::\1/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%Vclass (.+)\n/::\1/g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V \< .*//g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V\s//g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V^:://g'
endfunction

function! ColonToClassAndModule() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%Vclass /module /g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V::/ module /g'
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V module /\rmodule /g'
endfunction

function! CommaToBreakline() range
  silent! execute a:firstline . ',' . a:lastline . 's/\v%V,/,\r/g'
endfunction

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

command! RenameFile call RenameFile()
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

function! ReplaceText() range
  let selected_text = SelectedVisualModeText()
  if mode() == 'n'
    execute 'OverCommandLine %s/' . selected_text . '//g'
  else
    execute 'OverCommandLine %s/' . selected_text . '//g'
  endif
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

function! ChangeToFileFormatAndCopyAndSearchHistory()
  let selected_text = SelectedVisualModeText()
  let file_format = ChangeToFileFormat(selected_text)
  let @+=file_format
  echom 'Copyed! ' . file_format
  execute 'History'
endfunction

function! SearchByRG()
  if mode() == 'n'
    execute 'RG ' . input('RG/')
  else
    let selected = SelectedVisualModeText()
    let @+=selected
    echom 'Copyed! ' . selected
    execute 'RG ' . selected
    silent! exec "normal \<c-c>"
  endif
endfunction

function! RGBySelectedText()
  let selected = SelectedVisualModeText()
  let @+=selected
  echom 'Copyed! ' . selected
  execute 'RG ' . selected
endfunction

function! VimGrepBySelectedText()
  let selected = SelectedVisualModeText()
  let @+=selected
  echom 'Copyed! ' . selected
  execute 'vimgrep ' . input('vimgrep/') . " app/** lib/** config/** spec/** apidoc/**"
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
    " echo substitute('  34 hoge hoge', '^\s*\(\d*\)\s*.*', '\1', '')
    let num = str2nr(substitute(buf, '^\s*\(\d*\)\s*.*', '\1', ''))
    call add(listbufnums, num)
  endfor
  return listbufnums
endfunction

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

command! DeleteAllBuffers call DeleteAllBuffers()
function! DeleteAllBuffers()
  let allbufnums = ListAllBufNums()
  for num in allbufnums
    execute 'bwipeout! ' . num
  endfor
endfunction

command! DeleteAllTerms call DeleteAllTerms()
function! DeleteAllTerms()
  execute 'FloatermKill!'
endfunction

command! QuitAll call QuitAll()
function! QuitAll()
  call DeleteBufsWithoutExistingWindows()
  call SaveSession()
  call DeleteAllTerms()
  call DeleteAllBuffers()
  normal ZQ
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
Plug 'tpope/vim-markdown'
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'iberianpig/tig-explorer.vim'
Plug 'ruanyl/vim-gh-line'
Plug 'easymotion/vim-easymotion'
Plug 'liuchengxu/vim-which-key'
Plug 'osyo-manga/vim-over'
Plug 'voldikss/vim-floaterm'
Plug 'voldikss/fzf-floaterm'
Plug 'dart-lang/dart-vim-plugin'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-fugitive'
call plug#end()

" }}}

" ### plugin liuchengxu/vim-which-key ---------------------- {{{

if has('gui_running')
else
  let g:which_key_map =  {}
  call which_key#register('<Space>', "g:which_key_map")
  nnoremap <silent> <space> :WhichKey '<Space>'<CR>
  vnoremap <silent> <space> :<c-u>WhichKeyVisual '<Space>'<CR>
  set timeoutlen=200
  let g:which_key_use_floating_win = 1
  " let g:which_key_vertical = 1
  highlight WhichKeyFloating ctermbg=232
  autocmd FileType which_key highlight WhichKey ctermfg=13
  autocmd FileType which_key highlight WhichKeySeperator ctermfg=14
  autocmd FileType which_key highlight WhichKeyGroup ctermfg=11
  autocmd FileType which_key highlight WhichKeyDesc ctermfg=10
  let g:which_key_map.o = {
      \ 'name' : '+open' ,
      \ 's' : ['SearchByRG()' , 'Search file from text'],
      \ 'e' : ['ToggleNetrw()' , 'Open explore'],
      \ 'm' : ['PrevimOpen' , 'Open markdowexploren'],
      \ }
  let g:which_key_map.q = 'Quit'
  let g:which_key_map.s = {
      \ 'name' : '+split',
      \ 'h' : [ 'sp', 'Split horizontal' ],
      \ 'v' : [ 'vs', 'Split virtical' ]
      \ }
  let g:which_key_map.m = {
      \ 'name' : '+move',
      \ "'" : [ 'MoveTabRight()', 'Move tab right' ],
      \ ';' : [ 'MoveTabLeft()', 'Move tab left' ]
      \ }
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

" ### plugin tig-explorer.vim ---------------------- {{{

if has('gui_running')
else
"  nnoremap <space>gtb :TigBlame<CR>
"  nnoremap <space>gth :TigOpenCurrentFile<CR>
"  vnoremap <space>gtg y:TigGrep<Space><C-R>"<CR>
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

map  f <Plug>(easymotion-bd-f)
let g:EasyMotion_smartcase = 1

" }}}

" ### plugin osyo-manga/vim-over ---------------------- {{{

" nnoremap <space>or :call ReplaceText()<CR>
" vnoremap <space>or :call ReplaceText()<cr>

" }}}

" ### plugin voldikss/vim-floaterm ---------------------- {{{

" let g:floaterm_keymap_toggle = '<c-t>'
let g:floaterm_keymap_prev = '<S-left>'
let g:floaterm_keymap_next = '<S-right>'
let g:floaterm_keymap_new = '<F12>'
let g:floaterm_height = 0.9
let g:floaterm_width = 0.9
let g:floaterm_keymap_kill = '<c-q>'

noremap <c-t> :call TermToggle()<cr>

function! TermToggle()
  if len(ListTermBufNums()) == 0
    CreateFloaterm
  else
    FloatermToggle
  endif
endfunction

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

let g:ale_lint_on_text_changed = 0
let g:ale_linters = {
\ 'dart': ['dartfmt'],
\ }
let g:ale_fixers = {
\ 'dart': ['dartfmt'],
\}
let g:ale_fix_on_save = 1

" }}}

" ## fzf 設定 ---------------------- {{{

" nnoremap <space>os :call SearchByRG()<CR>
" vnoremap <space>os :<C-u>call RGBySelectedText()<CR>

function! s:GotoOrOpen(command, ...)
  for file in a:000
    if a:command == 'e'
      exec 'e ' . file
    else
      exec "tab drop " . file
    endif
  endfor
endfunction

command! -nargs=+ GotoOrOpen call s:GotoOrOpen(<f-args>)
let g:fzf_buffers_jump = 1

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 } }
" let g:fzf_preview_window = 'right:60%'
" This is default settings
let g:fzf_action = {
    \ 'ctrl-v': 'vsplit',
    \ 'ctrl-e': 'edit',
    \ 'enter': 'GotoOrOpen tab',
  \ }
let g:fzf_colors =
  \ {
    \ "fg":      ["fg", "CursorColumn"],
    \ "bg":      ["bg", "Normal"],
    \ "hl":      ["fg", "IncSearch"],
    \ "fg+":     ["fg", "CursorLine", "CursorColumn", "Normal"],
    \ "bg+":     ["bg", "CursorLine", "CursorColumn"],
    \ "hl+":     ["fg", "IncSearch"],
    \ 'info':    ['fg', 'PreProc'],
    \ 'spinner': ['fg', 'PreProc'],
    \ 'marker':  ['fg', 'PreProc'],
    \ 'pointer': ['fg', 'PreProc'],
    \ 'border':  ['fg', 'PreProc'],
    \ 'header':  ['fg', 'PreProc'],
 \  }

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
command! -bang -nargs=? -complete=dir History
    \ call fzf#vim#history(fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang -nargs=? -complete=dir Windows
    \ call fzf#vim#windows(fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

" Rg でカラー出力しない
" https://github.com/junegunn/fzf.vim/issues/488#issuecomment-350523157
" https://github.com/junegunn/fzf.vim/pull/696
" command! -bang -nargs=* Rg call fzf#vim#grep('rg --color never --column --line-number --no-heading --no-require-git '.shellescape(<q-args>), 1, <bang>0)
" デフォルト rg --column --line-number --no-heading --color=always --smart-case --
" command! -bang -nargs=? Rg
"     \ call fzf#vim#grep('rg --line-number --color=always --smart-case '.shellescape(<q-args>), 1, fzf#vim#with_preview({'options': ['--layout=reverse']}))

if has('gui_running')
else
  nnoremap <space>of :Files<CR>
  " HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れて :Files を開く
  vnoremap <space>of :call ChangeToFileFormatAndCopyAndSearchFiles()<cr>
endif

nnoremap <space>ob :Buffers<CR>
" HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れて :Buffers を開く
vnoremap <space>ob :call ChangeToFileFormatAndCopyAndSearchBuffers()<cr>

nnoremap <space>oh :History<CR>
" HogeHoge::FugaFuga の形式を hoge_hoge/fuga_fuga にしてクリップボードに入れて :History を開く
vnoremap <space>oh :call ChangeToFileFormatAndCopyAndSearchHistory()<cr>

nnoremap <space>ow :Windows<CR>

" ターミナルを開く
" nnoremap <space>ot :execute 'Buffers fish'<CR>

" 単語補完
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.3, 'height': 0.9, 'xoffset': 1 }})
" ファイル名補完
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files', {'window': { 'width': 0.3, 'height': 0.9, 'xoffset': 1 }})

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

command! DeleteBuffers call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all'
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

function! s:delete_windows(lines)
  execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[3]}))
endfunction

command! DeleteWindow call fzf#run(fzf#wrap({
  \ 'source': s:list_windows(),
  \ 'sink*': { lines -> s:delete_windows(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all,ctrl-d:deselect-all'
\ }))

" Rg, Ag が遅いので代わりにカスタムした RG を使う
" https://github.com/junegunn/fzf/wiki/Examples-(vim)#narrow-ag-results-within-vim
function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-e': 'edit',
               \ 'ctrl-v': 'vertical split',
               \ 'enter': 'GotoOrOpen tab'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

" bind は selection を参考に。http://manpages.ubuntu.com/manpages/focal/man1/fzf.1.html
command! -nargs=* RG call fzf#run(fzf#vim#with_preview(fzf#wrap({
\ 'source':  printf('rg --column --no-heading --color always --smart-case "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--layout=reverse --ansi --expect=ctrl-v,enter,ctrl-a,ctrl-e '.
\            '--multi --bind=ctrl-u:toggle,ctrl-p:toggle-preview '.
\            '--color hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ })))

command! -nargs=0 OpenNote call fzf#run(fzf#wrap({
\ 'source': 'ls ~/.vim/note',
\ 'sink':  function('<sid>open_note'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

function! s:open_note(line)
  try
    call fzf#run(fzf#wrap({
    \ 'source':  'cat ~/.vim/note/' . a:line,
    \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 },
    \ 'sink':   function('s:open_selected_file')}))
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

function! s:open_selected_file(line)
  execute 'vs ' . a:line
endfunction

command! -nargs=0 DiffFile call fzf#run(fzf#wrap({
\ 'source': 'rg --files',
\ 'sink':  function('<sid>diff_files'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

function! s:diff_files(line)
  execute 'vertical diffsplit ' . a:line
endfunction

command! -nargs=0 OpenAnotherProjectFile call fzf#run(fzf#wrap({
\ 'source': 'ghq list --full-path',
\ 'sink':  function('<sid>open_another_project_file'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

function! s:open_another_project_file(line)
  try
    call fzf#run(fzf#wrap({
    \ 'source':  'rg --files ' . a:line,
    \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 },
    \ 'sink':   function('s:open_selected_file')}))
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

command! -nargs=0 SwitchProject call fzf#run(fzf#wrap({
\ 'source': 'ghq list --full-path',
\ 'sink':  function('<sid>open_project'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

function! s:open_project(project)
  call DeleteBufsWithoutExistingWindows()
  call SaveSession()
  call DeleteAllTerms()
  call DeleteAllBuffers()
  silent! execute 'cd ' . a:project
  CreateFloaterm
  CreateFloaterm
  CreateFloaterm
  sleep 100m
  FloatermHide
endfunction

command! -nargs=0 SwitchProjectWithKeepingTerminal call fzf#run(fzf#wrap({
\ 'source': 'ghq list --full-path',
\ 'sink*':  function('<sid>switch_project_with_keeping_terminal'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

function! s:switch_project_with_keeping_terminal(project)
  call DeleteBufsWithoutExistingWindows()
  call SaveSession()
  call DeleteAllBuffers()
  silent! execute 'cd ' . a:project[0]
endfunction

nnoremap <space><space> :SelectFunction<CR>
command! -nargs=0 SelectFunction call fzf#run(fzf#wrap({
\ 'source': 'cat ~/.vim/functions/normal',
\ 'sink': '',
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

vnoremap <space><space> :call SelectVisualFunction()<CR>
function! SelectVisualFunction() range
  execute 'SelectVidualFunction'
endfunction
command! -nargs=* SelectVidualFunction call fzf#run(fzf#wrap({
\ 'source': 'cat ~/.vim/functions/visual',
\ 'sink*':  function('<sid>select_visual_function_handler'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

function! s:select_visual_function_handler(lines) range
  execute 'call '. a:lines[0] . '()'
endfunction

command! -nargs=0 SwitchSession call fzf#run(fzf#wrap({
\ 'source': 'ls ~/.vim/sessions',
\ 'sink':  function('<sid>load_session'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

function! s:load_session(session)
  call DeleteBufsWithoutExistingWindows()
  call SaveSession()
  call DeleteAllTerms()
  call DeleteAllBuffers()
  silent! execute 'source ~/.vim/sessions/' . a:session
  silent! execute 'source $MYVIMRC'
  sleep 100m
  CreateFloaterm
  CreateFloaterm
  CreateFloaterm
  sleep 100m
  FloatermHide
endfunction

command! -nargs=0 DeleteSessions call fzf#run(fzf#wrap({
\ 'source': 'ls ~/.vim/sessions',
\ 'options': '--multi --bind=ctrl-a:select-all,ctrl-i:toggle+down ',
\ 'sink*':  function('<sid>delete_sessions'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

function! s:delete_sessions(sessions)
  for session in a:sessions
    call delete(expand('~/.vim/sessions/' . session))
  endfor
endfunction

command! -nargs=0 SwitchSessionWithKeepingTerminal call fzf#run(fzf#wrap({
\ 'source': 'ls ~/.vim/sessions',
\ 'sink*':  function('<sid>switch_session_with_keeping_terminal'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
\ }))

function! s:switch_session_with_keeping_terminal(session)
  call SaveSession()
  silent! execute 'source ~/.vim/sessions/' . a:session[0]
  silent! execute 'source $MYVIMRC'
endfunction

command! -bang DeleteFloaterms call fzf#run(fzf#wrap({
\ 'source': s:fetch_term_names(),
\ 'options': '--multi --bind=ctrl-a:select-all,ctrl-i:toggle+down ',
\ 'sink*': function('<sid>delete_floaterms'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 },
\ },
\ <bang>0
\ ))

function! s:fetch_term_names()
  let bufnums = ListTermBufNums()
  let bufs = []
  for num in bufnums
    let opts = getbufvar(num, 'floaterm_opts', {})
    let name = opts['name'] . ' : ' . num
    call add(bufs, name)
  endfor
  return bufs
endfunction

function! s:delete_floaterms(line) abort
  for buf in a:line
    let num = str2nr(substitute(buf, '^.*\s\:\s\(\d*\)', '\1', ''))
    execute 'bwipeout! ' . num
  endfor
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

command! -bang DiffFileGitBranch call fzf#run(fzf#wrap({
\ 'source': 'git --no-pager branch',
\ 'sink': function('<sid>diff_file_git_branch'),
\ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 },
\ },
\ <bang>0
\ ))

function! s:diff_file_git_branch(branch)
  execute 'Gvdiff ' . a:branch
  SwapWindow
endfunction

" }}}

" ## LSP 設定 ---------------------- {{{

let g:lsp_auto_enable = 1
let g:lsp_signs_enabled = 1         " enable diagnostic signs / we use ALE for now
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_signs_error = {'text': '✖'}
let g:lsp_signs_warning = {'text': '~'}
let g:lsp_signs_hint = {'text': '?'}
let g:lsp_signs_information = {'text': '!!'}
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/.vim/vim-lsp.log')

 if executable('solargraph')
    " gem install solargraph
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'initialization_options': {"diagnostics": "true"},
        \ 'whitelist': ['ruby'],
        \ })
endif

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:on_lsp_buffer_enabled() abort
"   setlocal omnifunc=lsp#complete
"   setlocal signcolumn=yes
"   nmap <buffer> gd <plug>(lsp-definition)
"   nmap <buffer> <f2> <plug>(lsp-rename)
"   inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
" endfunction
"
" augroup lsp_install
"   au!
"   autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
" augroup END
" command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')
"
" let g:lsp_diagnostics_enabled = 1
" let g:lsp_diagnostics_echo_cursor = 1
" let g:asyncomplete_auto_popup = 1
" let g:asyncomplete_auto_completeopt = 0
" let g:asyncomplete_popup_delay = 200
" let g:lsp_text_edit_enabled = 1

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
