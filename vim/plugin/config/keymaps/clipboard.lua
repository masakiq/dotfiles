-- ビジュアルモードで選択した範囲をクリップボードにコピー
vim.keymap.set("v", "y", '"+y', { noremap = true })

-- ビジュアルモードで選択した範囲にクリップボードからペースト
vim.keymap.set("v", "p", '"+p', { noremap = true })

-- ビジュアルモードで選択した範囲をカットしてクリップボードにコピー
vim.keymap.set("v", "d", '"+d', { noremap = true })

-- ビジュアルモードで選択した範囲をカットしてクリップボードにコピー
vim.keymap.set("v", "x", '"+x', { noremap = true })

-- message をコピーする
vim.keymap.set("n", "<space>m", function()
  local messages = vim.api.nvim_exec2("1messages", { output = true }).output
  vim.fn.setreg("+", messages)
  vim.notify("last messages copied!", vim.log.levels.INFO)
end, { noremap = true })

-- 現在のパスをコピーする
vim.keymap.set("n", "<space>c", ":CopyCurrentPath<cr>", { noremap = true })
