-- 選択した両側を指定した記号で囲む
vim.keymap.set("v", "'", "c'<C-r>\"'<Esc>", { noremap = true })
vim.keymap.set("v", '"', 'c"<C-r>""<Esc>', { noremap = true })
vim.keymap.set("v", "`", 'c`<C-r>"`<Esc>', { noremap = true })
vim.keymap.set("v", "(", 'c(<C-r>")<Esc>', { noremap = true })
vim.keymap.set("v", ")", 'c(<C-r>")<Esc>', { noremap = true })
vim.keymap.set("v", "[", 'c[<C-r>"]<Esc>', { noremap = true })
vim.keymap.set("v", "]", 'c[<C-r>"]<Esc>', { noremap = true })
vim.keymap.set("v", "{", 'c{<C-r>"}<Esc>', { noremap = true })
vim.keymap.set("v", "}", 'c{<C-r>"}<Esc>', { noremap = true })
vim.keymap.set("v", "<", 'c<<C-r>"><Esc>', { noremap = true })
vim.keymap.set("v", ">", 'c<<C-r>"><Esc>', { noremap = true })
vim.keymap.set("v", "*", 'c*<C-r>"*<Esc>', { noremap = true })
vim.keymap.set("v", "~", 'c~<C-r>"~<Esc>', { noremap = true })
vim.keymap.set("v", "|", 'c|<C-r>"|<Esc>', { noremap = true })
vim.keymap.set("v", "<space>", 'c<space><C-r>" <Esc>', { noremap = true })

-- 選択した両側を一文字ずつ削除
vim.keymap.set("v", "<bs>", 'c<Right><Bs><Bs><C-r>"<Esc>', { noremap = true })
