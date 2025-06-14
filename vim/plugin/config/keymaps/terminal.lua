-- ターミナルモードで jf を押すとノーマルモードに切り替える
vim.keymap.set("t", "jf", "<C-\\><C-n>", { noremap = true })
