" ## プラグイン設定 ---------------------- {{{

call plug#begin('~/.vim/plugged')
" ---- Do not change the following lines ----
Plug 'junegunn/fzf', { 'dir': '~/.fzf', '   do': './install --all' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
" -------------------------------------------
" Code Completion and Linting
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Language Support
Plug 'dart-lang/dart-vim-plugin',           { 'commit': '928302ec931caf0dcf21835cca284ccd2b192f7b', 'for': 'dart' }
Plug 'jparise/vim-graphql',                 { 'commit': '996749a7d69a3709768fa8c4d259f79b5fd9bdb1' }
Plug 'maxmellon/vim-jsx-pretty',            { 'commit': '6989f1663cc03d7da72b5ef1c03f87e6ddb70b41', 'for': ['javascript', 'typescript'] }
Plug 'rcmdnk/vim-markdown',                 { 'commit': '9a5572a18b2d0bbe96b2ed625f5fbe0462dbd801', 'for': 'markdown' }

" Interface
Plug 'folke/tokyonight.nvim',               { 'commit': '2c85fad417170d4572ead7bf9fdd706057bd73d7', 'as': 'tokyonight' }
Plug 'stevearc/oil.nvim',                   { 'commit': 'cca1631d5ea450c09ba72f3951a9e28105a3632c' }
Plug 'nvim-tree/nvim-web-devicons',         { 'commit': '56f17def81478e406e3a8ec4aa727558e79786f3' }
Plug 'junegunn/fzf.vim',                    { 'commit': 'f7c7b44764a601e621432b98c85709c9a53a7be8' }
Plug 'voldikss/vim-floaterm',               { 'commit': '4e28c8dd0271e10a5f55142fb6fe9b1599ee6160' }
Plug 'voldikss/fzf-floaterm',               { 'commit': 'c023f97e49e894ac5649894b7e05505b6df9b055' }
Plug 'MunifTanjim/nui.nvim',                { 'commit': '61574ce6e60c815b0a0c4b5655b8486ba58089a1' }
Plug 'masakiq/vim-tabline',                 { 'commit': 'ddebfdd25e6de91e3e89c2ec18c80cd3d2adadd9' }
Plug 'liuchengxu/vim-which-key',            { 'commit': '470cd19ce11b616e0640f2b38fb845c42b31a106' }

" Navigation
Plug 'easymotion/vim-easymotion',           { 'commit': 'b3cfab2a6302b3b39f53d9fd2cd997e1127d7878' }
Plug 'haya14busa/incsearch-easymotion.vim', { 'commit': 'fcdd3aee6f4c0eef1a515727199ece8d6c6041b5' }
Plug 'haya14busa/incsearch-fuzzy.vim',      { 'commit': 'b08fa8fbfd633e2f756fde42bfb5251d655f5403' }
Plug 'haya14busa/incsearch.vim',            { 'commit': 'c83de6d1ac31d173d7c3ffee0ad61dc643ee4f08' }
Plug 'matze/vim-move',                      { 'commit': '244a2908ffbca3d09529b3ec24c2c090f489f401' }
Plug 'mg979/vim-visual-multi',              { 'commit': '724bd53adfbaf32e129b001658b45d4c5c29ca1a' }

" Editing Assistance
Plug 'jiangmiao/auto-pairs',                { 'commit': '39f06b873a8449af8ff6a3eee716d3da14d63a76' }
Plug 'wellle/targets.vim',                  { 'commit': '6325416da8f89992b005db3e4517aaef0242602e' }
Plug 'tpope/vim-commentary',                { 'commit': 'c4b8f52cbb7142ec239494e5a2c4a512f92c4d07' }
Plug 'tpope/vim-surround',                  { 'commit': '3d188ed2113431cf8dac77be61b842acb64433d9' }
Plug 'mattn/vim-maketable',                 { 'commit': 'd72e73f333c64110524197ec637897bd1464830f' }
Plug 'mtdl9/vim-log-highlighting',          { 'commit': '1037e26f3120e6a6a2c0c33b14a84336dee2a78f' }

" Copilot
Plug 'nvim-lua/plenary.nvim',               { 'commit': 'a3e3bc82a3f95c5ed0d7201546d5d2c19b20d683' }
Plug 'CopilotC-Nvim/CopilotChat.nvim',      { 'commit': '16d897fd43d07e3b54478ccdb2f8a16e4df4f45a' }
Plug 'zbirenbaum/copilot.lua',              { 'commit': 'c1bb86abbed1a52a11ab3944ef00c8410520543d' }

" Claude Code
" Plug 'coder/claudecode.nvim',             { 'commit': '91357d810ccf92f6169f3754436901c6ff5237ec' }
Plug 'masakiq/claudecode.nvim',             { 'branch': 'diff_strip_path_prefix' }
call plug#end()

" }}}

if has('gui_running')
else
  let g:which_key_map =  {}
  call which_key#register('<space>', "g:which_key_map")
  call which_key#register('<leader>', "g:which_key_map")
  nnoremap <silent> <space> :WhichKey '<space>'<CR>
  nnoremap <silent> <leader> :WhichKey '<leader>'<CR>
  vnoremap <silent> <space> :<c-u>WhichKeyVisual '<space>'<CR>
  vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<leader>'<CR>
  let g:which_key_use_floating_win = 1
  " let g:which_key_vertical = 1
  highlight WhichKeyFloating ctermbg=232
  autocmd FileType which_key highlight WhichKey ctermfg=13
  autocmd FileType which_key highlight WhichKeySeperator ctermfg=14
  autocmd FileType which_key highlight WhichKeyGroup ctermfg=11
  autocmd FileType which_key highlight WhichKeyDesc ctermfg=10
  let g:which_key_map.q = 'Quit'
  let g:which_key_map.w = 'Save'
  let g:which_key_map.i = 'Toggle hlsearch'
  let g:which_key_map.h = 'Move left'
  let g:which_key_map.j = 'Move down'
  let g:which_key_map.k = 'Move up'
  let g:which_key_map.l = 'Move right'
  let g:which_key_map.t = 'Tab new'
  let g:which_key_map.a = 'Toggle QuickFix'
  let g:which_key_map.m = 'Copy last messages'
  " let g:which_key_map[';'] = 'Previous QuickFix'
  " let g:which_key_map["'"] = 'Next QuickFix'
  let g:which_key_map["/"] = 'Search Word or Open File'
  let g:which_key_map["."] = 'Spread horizontally right'
  let g:which_key_map[","] = 'Spread horizontally left'
  let g:which_key_map["="] = 'Spread vertically top'
  let g:which_key_map["-"] = 'Spread vertically bottom'
  let g:which_key_map['<Right>'] = 'Expand right'
  let g:which_key_map['<Left>'] = 'Expand left'
  let g:which_key_map['<Up>'] = 'Expand up'
  let g:which_key_map['<Down>'] = 'Expand down'
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
" let g:EasyMotion_use_migemo = 1

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

" ## dart-lang/dart-vim-plugin ---------------------- {{{

let dart_html_in_string = v:true
let g:dart_style_guide = 2
" let g:dart_format_on_save = 1

" }}}

" ## mg979/vim-visual-multi ---------------------- {{{

let g:VM_maps = {}
let g:VM_maps["Align"]                = '<M-a>'
let g:VM_maps["Surround"]             = 'S'
let g:VM_maps["Case Conversion Menu"] = 'C'
let g:VM_maps["Add Cursor Down"]      = '<M-Down>'
let g:VM_maps["Add Cursor Up"]        = '<M-Up>'

" }}}

" ## masakiq/vim-tabline ---------------------- {{{

let g:tabline_charmax = 40

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

"## maxmellon/vim-jsx-pretty ---------------------- {{{

let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" }}}

"## tpope/vim-commentary ---------------------- {{{

" noremap <space>c :Commentary<cr>
noremap <leader>c :Commentary<cr>

" }}}

"## rcmdnk/vim-markdown ---------------------- {{{

let g:vim_markdown_folding_disabled = 0
let g:vim_markdown_folding_level = 4

" }}}

"## voldikss/vim-floaterm ---------------------- {{{

" let g:floaterm_keymap_toggle = '<c-t>'
let g:floaterm_keymap_prev = '<S-left>'
let g:floaterm_keymap_next = '<S-right>'
let g:floaterm_keymap_new = '<F12>'
let g:floaterm_height = 0.95
let g:floaterm_width = 0.95
let g:floaterm_title = 'terminal:$1/$2'
let g:floaterm_keymap_kill = '<c-q>'
tnoremap <C-[> <C-\><C-n><C-w><C-w>

tnoremap <M-down> <C-\><C-n>:FloatermUpdate --width=0.95 --height=0.35 --position=bottom --wintype=float<cr>
tnoremap <M-up> <C-\><C-n>:FloatermUpdate --width=0.95 --height=0.95 --position=center --wintype=float<cr>

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
let g:fzf_preview_window = 'down,50%'
let g:fzf_action = {
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-s': 'split',
      \ 'ctrl-e': 'edit',
      \ 'enter': 'GotoOrOpen tab',
      \ }

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
      \         '--bind=ctrl-u:toggle,?:toggle-preview'
      \       ]
      \     }
      \   ),
      \   <bang>0
      \ )
command! -bang -nargs=? -complete=dir Buffers
      \ call fzf#vim#buffers(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang -nargs=? -complete=dir Windows
      \ call fzf#vim#windows(fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

nnoremap <space>of :call OpenFiles()<CR>
nnoremap <space>ob :Buffers<CR>
nnoremap <space>ow :Windows<CR>

" 単語補完
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.3, 'height': 0.9, 'xoffset': 1 }})
" ファイル名補完
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files', {'window': { 'width': 0.3, 'height': 0.9, 'xoffset': 1 }})

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

command! PlugGetLatestCommits :call PlugGetLatestCommits()
function! PlugGetLatestCommits()
  let command = '~/.config/nvim/lua/plug_get_latest_commits.lua'
  silent! execute 'r!' . command
endfunction

" }}}

" ## ファイル操作 ---------------------- {{{

function! OpenFiles(...)
  let l:path = get(a:, 1, "")
  let l:sort = get(a:, 2, "")
  if l:path == ""
    let l:path = "--sortr modified"
  endif
  call fzf#run(fzf#vim#with_preview(fzf#wrap({
        \ 'source': printf("rg --hidden --files --glob '!**/.git/**' %s %s", l:sort, l:path),
        \ 'sink*': function('s:open_files'),
        \ 'options': [
        \   '--prompt', 'Files> ',
        \   '--multi',
        \   '--expect=ctrl-v,ctrl-s,enter,ctrl-a,ctrl-e,ctrl-x',
        \   '--bind=ctrl-a:select-all,ctrl-u:toggle,?:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up',
        \ ],
        \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
        \ })))
endfunction

command! -bang OpenAllFiles call OpenAllFiles()
function! OpenAllFiles()
  try
    call fzf#run(fzf#wrap({
          \ 'source': 'rg --hidden --files --no-ignore --sortr modified | grep -v .git',
          \ 'sink*': function('s:open_files'),
          \ 'options': [
          \   '--prompt', 'AllFiles> ',
          \   '--multi',
          \   '--expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x',
          \   '--bind=ctrl-a:select-all,ctrl-u:toggle,?:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up',
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
        \   'ctrl-s': 'split ',
        \   'enter': 'tab drop '
        \ },
        \ a:lines[0], 'tab drop ')
  if a:lines[0] == 'ctrl-x'
    call s:open_quickfix_list(cmd, a:lines[1:])
  else
    for file in a:lines[1:]
      let escaped_file = substitute(file, " ", "\\\\ ", 'g')
      exec cmd . escaped_file
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


nnoremap <space>ot :OpenTargetFile<CR>
command! OpenTargetFile call OpenTargetFile()
function! OpenTargetFile()
  cd .
  let target_path=''
  let path=expand('%')
  if path =~ '^app/'
    if path =~ '^app/controllers/'
      let target_path=substitute(substitute(expand('%'), '^app/controllers/', 'spec/', ''), '\v(.+)_controller.rb', '\1_spec.rb', '')
    else
      let target_path=substitute(substitute(expand('%'), '^app/', 'spec/', ''), '\v(.+).rb', '\1_spec.rb', '')
    endif
  elseif path =~ '^lib/'
    let target_path=substitute(substitute(expand('%'), '^lib/', 'spec/lib/', ''), '\v(.+).rb', '\1_spec.rb', '')
  elseif path =~ '^spec/'
    if path =~ '^spec/requests/'
      let target_path=substitute(substitute(expand('%'), '^spec/requests/', 'app/', ''), '\v(.+)\/.+_spec.rb', '\1.rb', '')
    elseif path =~ '^spec/lib/'
      let target_path=substitute(substitute(expand('%'), '^spec/lib/', 'lib/', ''), '\v(.+)_spec.rb', '\1.rb', '')
    else
      let target_path=substitute(substitute(expand('%'), '^spec/', 'app/', ''), '\v(.+)_spec.rb', '\1.rb', '')
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
endfunction

command! QuitAll call QuitAll()
function! QuitAll()
  call DeleteBufsWithoutExistingWindows()
  call DeleteBuffers()
  normal ZQ
endfunction

nnoremap <space>oh :History<CR>

" }}}

" ## ウィンドウ操作 ---------------------- {{{

command! SwapWindow call SwapWindow()
function! SwapWindow()
  " https://stackoverflow.com/questions/2228353/how-to-swap-files-between-windows-in-vim
  silent! exec "normal \<c-w>x"
endfunction

function! s:delete_windows(lines)
  execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[3]}))
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

command! ClearAllBuffers call ClearAllBuffers()
function! ClearAllBuffers()
  if !&modifiable
    echo "Buffer is not modifiable"
    return
  endif

  let current_win = winnr()

  for win in range(1, winnr('$'))
    exec win . 'wincmd w'
    %delete _
    write
  endfor

  exec current_win . 'wincmd w'
endfunction

" }}}

" ## レジスタ操作 ---------------------- {{{

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

" ## プロジェクト横断 ---------------------- {{{

nnoremap <space>op :call SwitchProject()<cr>
function! SwitchProject()
  call fzf#run(fzf#vim#with_preview(fzf#wrap({
        \ 'source': 'ghq list --full-path',
        \ 'sink':  function('s:open_project'),
        \ 'options': [
        \   '--prompt', 'Project> ',
        \   '--bind=ctrl-a:select-all,ctrl-u:toggle,?:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up',
        \ ],
        \ 'placeholder': '{}/README.md',
        \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
        \ })))
endfunction

function! s:open_project(project)
  call DeleteBufsWithoutExistingWindows()
  call DeleteBuffers()
  silent! execute 'cd ' . a:project
  call s:setTitle()
endfunction

" }}}

" ## 検索 ---------------------- {{{

" https://github.com/junegunn/fzf/wiki/Examples-(vim)#narrow-ag-results-within-vim
" bind は selection を参考に。http://manpages.ubuntu.com/manpages/focal/man1/fzf.1.html
" command! -nargs=* RG call fzf#run(fzf#vim#with_preview(fzf#wrap({
"       \ 'source':  printf("rg --column --no-heading --color always --smart-case '%s'",
"       \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
"       \ 'sink*':    function('s:open_files_via_rg'),
"       \ 'options': '--layout=reverse --ansi --expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x '.
"       \            '--prompt="RG> " '.
"       \            '--delimiter : --preview-window +{2}-/2 '.
"       \            '--multi --bind=ctrl-a:select-all,ctrl-u:toggle,?:toggle-preview '.
"       \            '--color hl:68,hl+:110,info:110,spinner:110,marker:110,pointer:110',
"       \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
"       \ })))

function! SearchWord(word, ...)
  let l:path = get(a:, 1, "")
  let l:sort = get(a:, 2, "")
  if a:word == ''
    call OpenFiles(l:path, l:sort)
    return
  endif
  call fzf#run(fzf#vim#with_preview(fzf#wrap({
      \ 'source':  printf("rg --column --no-heading --color always --smart-case --fixed-strings %s %s", shellescape(a:word), l:path),
      \ 'sink*':    function('s:open_files_via_rg'),
      \ 'options': '--layout=reverse --ansi --expect=ctrl-v,enter,ctrl-a,ctrl-e,ctrl-x '.
      \            '--prompt="Search> " '.
      \            '--delimiter : --preview-window +{2}-/2 '.
      \            '--multi --bind=ctrl-a:select-all,ctrl-u:toggle,?:toggle-preview,ctrl-n:preview-down,ctrl-p:preview-up ',
      \ 'window': { 'width': 0.9, 'height': 0.9, 'xoffset': 0.5, 'yoffset': 0.5 }
      \ })))
endfunction

vnoremap <space>/ :call SearchWordBySelectedText()<cr>
function! SearchWordBySelectedText()
  let selected = SelectedVisualModeText()
  let @+=selected
  echom 'Copyed! ' . selected
  call SearchWord(selected)
endfunction

function! s:open_files_via_rg(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get(
        \ {
        \   'ctrl-e': 'edit',
        \   'ctrl-v': 'vertical split',
        \   'enter': 'tab drop '
        \ },
        \ a:lines[0], 'tab drop ')
  let list = map(a:lines[1:], 's:open_quickfix(v:val)')

  if len(list) == 1
    let first = list[0]
    let escaped_file = substitute(first.filename, " ", "\\\\ ", 'g')
    execute cmd escaped_file
    execute first.lnum
    execute 'normal!' first.col.'|zz'
  else
    if a:lines[0] == 'ctrl-x'
      let first = list[0]
      let escaped_file = substitute(first.filename, " ", "\\\\ ", 'g')
      execute cmd escaped_file
      execute first.lnum
      execute 'normal!' first.col.'|zz'
      call setqflist(list)
      copen
      wincmd p
    else
      for item in list
        let escaped_file = substitute(item.filename, " ", "\\\\ ", 'g')
        exec 'tab drop ' . escaped_file
        execute item.lnum
        execute 'normal!' item.col.'|zz'
      endfor
    endif
  endif
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
  let buflist = getbufinfo()
  let listbufnums = []
  for buf in buflist
    call add(listbufnums, buf.bufnr)
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

" }}}

" ## for test lines ---------------------- {{{



" }}}
