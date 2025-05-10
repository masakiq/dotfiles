-- リーダーキーは他のマッピングより前に行う必要がある
vim.g.mapleader = ","

-- リーダーキーのディレイタイム
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 500

vim.cmd([[
  source $HOME/.vimrc
]])

-- .nvim.lua のロードを有効にする
vim.o.exrc = true

-- .nvim.lua 内の外部プログラム呼び出しを禁止する
vim.o.secure = true

-- データディレクトリ内に lazy.nvim がなければクローン
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- ランタイムパスに追加
vim.opt.rtp:prepend(lazypath)
