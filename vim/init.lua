-- リーダーキーは他のマッピングより前に行う必要がある
vim.g.mapleader = ","

-- リーダーキーのディレイタイム
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 500

-- .nvim.lua のロードを有効にする
vim.o.exrc = true

-- .nvim.lua 内の外部プログラム呼び出しを禁止する
vim.o.secure = true

require("config.legacy").setup()
require("config.lazy").setup()
