-- ウインドウ幅を右に広げる
vim.keymap.set("n", "<space>.", "41<C-w>>", { noremap = true })

-- ウインドウ幅を左に広げる
vim.keymap.set("n", "<space>,", "41<C-w><", { noremap = true })

-- ウインドウ高さを高くする
vim.keymap.set("n", "<space>=", "9<C-w>+", { noremap = true })

-- ウインドウ高さを低くする
vim.keymap.set("n", "<space>-", "9<C-w>-", { noremap = true })
