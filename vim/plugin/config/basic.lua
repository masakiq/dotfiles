vim.api.nvim_create_autocmd("FileType", {
  pattern = "vim",
  group = vim.api.nvim_create_augroup("filetype_vim", { clear = true }),
  callback = function()
    vim.opt_local.foldmethod = "marker"
  end,
})

-- vi 非互換
vim.opt.compatible = false

-- フォーマット設定
vim.opt.encoding = "utf-8"
vim.opt.fileformats = { "unix", "dos", "mac" }

-- 1. 重複を避けるための augroup を作成
local resize_group = vim.api.nvim_create_augroup("ResizeEqualWindows", { clear = true })

-- 2. VimResized イベントで wincmd = を実行する autocmd を作成
vim.api.nvim_create_autocmd("VimResized", {
  group = resize_group,
  callback = function()
    -- 全ウィンドウを等幅・等高にリサイズ
    vim.cmd("wincmd =")
  end,
})
