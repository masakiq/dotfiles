-- 補完時の挙動を一般的な IDE と同じにする
vim.opt.completeopt = { "menuone", "noinsert" }

-- AutoPairsとの共存を考慮したキーマッピング
-- <CR>マッピングはAutoPairsに任せる
-- vim.keymap.set('i', '<CR>', function()
--   return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
-- end, { expr = true })

-- 他のマッピングは競合しないので残す
vim.keymap.set("i", "<C-n>", function()
  return vim.fn.pumvisible() == 1 and "<Down>" or "<C-n>"
end, { expr = true })

vim.keymap.set("i", "<C-p>", function()
  return vim.fn.pumvisible() == 1 and "<Up>" or "<C-p>"
end, { expr = true })

vim.keymap.set("i", "<C-j>", function()
  return vim.fn.pumvisible() == 1 and "<Down>" or "<C-n>"
end, { expr = true })

vim.keymap.set("i", "<C-k>", function()
  return vim.fn.pumvisible() == 1 and "<Up>" or "<C-p>"
end, { expr = true })
