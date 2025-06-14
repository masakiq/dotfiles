-- 表示行単位でのカーソル移動の設定
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("v", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })
vim.keymap.set("v", "k", "gk", { noremap = true })
vim.keymap.set("n", "0", "g0", { noremap = true })
vim.keymap.set("v", "0", "g0", { noremap = true })
vim.keymap.set("n", "^", "g^", { noremap = true })
vim.keymap.set("v", "^", "g^", { noremap = true })
vim.keymap.set("n", "$", "g$", { noremap = true })

-- 効率的なカーソル移動のショートカット
vim.keymap.set("n", "<C-e>", "$a", { noremap = true })
vim.keymap.set("n", "<C-a>", "^i", { noremap = true })
vim.keymap.set("n", "<C-u>", "7gk", { noremap = true })
vim.keymap.set("n", "<C-d>", "7gj", { noremap = true })

-- 挿入モードでの移動ショートカット
vim.keymap.set("i", "<M-right>", "<right><right><right><right><right>", { noremap = true })
vim.keymap.set("i", "<M-left>", "<left><left><left><left><left>", { noremap = true })

-- ウインドウ間移動
vim.keymap.set("n", "<space>h", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<space>j", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<space>k", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<space>l", "<C-w>l", { noremap = true })
