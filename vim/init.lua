vim.cmd([[
  source $HOME/.vimrc
]])

-- .nvim.lua のロードを有効にする
vim.o.exrc = true

-- .nvim.lua 内の外部プログラム呼び出しを禁止する
vim.o.secure = true
