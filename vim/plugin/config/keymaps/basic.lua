-- リーダーキーを , にする
vim.g.mapleader = ","

-- リーダーキーのディレイタイム
vim.opt.timeout = true
vim.opt.timeoutlen = 800
vim.opt.ttimeoutlen = 100

-- キーマッピング
vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("i", "ｊｋ", "<esc>", { silent = true })
vim.keymap.set("i", "<C-c>", "<esc>")
vim.keymap.set("v", "<C-c>", "<esc>")
vim.keymap.set("n", "あ", "a")
vim.keymap.set("n", "い", "i")
vim.keymap.set("n", "お", "o")

-- Insert モードで Emacs のキーバインドを使えるようにする
vim.keymap.set("i", "<C-p>", "<Up>")
vim.keymap.set("i", "<C-n>", "<Down>")
vim.keymap.set("i", "<C-b>", "<Left>")
vim.keymap.set("i", "<C-f>", "<Right>")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-d>", "<Del>")
vim.keymap.set("i", "<C-h>", "<BS>")
vim.keymap.set("i", "<C-a>", "<Home>")
vim.keymap.set("i", "<C-k>", "<esc>`^DA")

-- バックスペースキーを無効にする
vim.keymap.set("v", "<BS>", "<nop>")
vim.keymap.set("n", "<BS>", "<nop>")

-- ビジュアルモードで単語の最後まで選択する
vim.keymap.set("v", "E", "$h")

-- ビジュアルモードでライン選択(ただし行末の改行は除く)
vim.keymap.set("v", "V", "0<esc>v$h")
vim.keymap.set("v", "a", "<esc>G$vgg0")
vim.keymap.set("n", "V", "0v$h")

-- J で後の行を連結したときに空白を入れない
vim.keymap.set("n", "J", "gJ")

-- インサートモードを抜けるときに IME を "英数" に切り替える
-- https://github.com/laishulu/macism
if vim.fn.executable("macism") == 1 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      os.execute("macism com.apple.keylayout.ABC")
    end,
  })
end

-- 検索ハイライトの切り替え（<space>i）
vim.keymap.set("n", "<space>i", function()
  vim.opt.hlsearch = not vim.opt.hlsearch:get()
end, { noremap = true, silent = true, desc = "検索ハイライトの切り替え" })

-- 行番号表示の切り替え（<space>n）
vim.keymap.set("n", "<space>n", function()
  vim.opt.number = not vim.opt.number:get()
end, { noremap = true, silent = true, desc = "行番号表示の切り替え" })
