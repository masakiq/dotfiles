-- 大文字小文字の両方が含まれている場合は大文字小文字を区別
vim.opt.smartcase = true

-- インクリメンタルサーチ
vim.opt.incsearch = true

-- 検索ハイライト
vim.opt.hlsearch = true

-- ビジュアルモードで選択したときに、検索した単語をハイライトにする
-- vim.cmd([[syn match cppSTL /\(::.*\)\@<=\<find\>/]])
-- :vim(grep) したときに自動的にquickfix-windowを開く
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "*grep*",
  command = "cwindow",
})

-- quickfix-window のサイズ調整
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.cmd("15wincmd_")
  end,
})

-- 検索時のハイライトを無効化
vim.opt.hlsearch = false
