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
