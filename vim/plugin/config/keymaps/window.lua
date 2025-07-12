-- ウインドウ幅を右に広げる
vim.keymap.set("n", "<space><left>", "20<C-w>>", { noremap = true })

-- ウインドウ幅を左に広げる
vim.keymap.set("n", "<space><right>", "20<C-w><", { noremap = true })

-- ウインドウ高さを高くする
vim.keymap.set("n", "<space><down>", "5<C-w>+", { noremap = true })

-- ウインドウ高さを低くする
vim.keymap.set("n", "<space><up>", "5<C-w>-", { noremap = true })
