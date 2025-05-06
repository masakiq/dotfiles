-- menu: 補完候補をポップアップメニューで表示する
-- menuone: 一つだけの候補でもポップアップメニューを表示する
-- noselect: 最初の候補を自動的に選択しない
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.keymap.set("n", "<space>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format document" })
local telescope = require("telescope.builtin")
vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = bufnr, desc = "Go to definition with Telescope" })
vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = bufnr, desc = "Find references with Telescope" })
vim.keymap.set(
  "n",
  "gi",
  telescope.lsp_implementations,
  { buffer = bufnr, desc = "Go to implementation with Telescope" }
)
vim.keymap.set("n", "<space>ds", telescope.lsp_document_symbols, { buffer = bufnr, desc = "Document symbols" })
vim.keymap.set("n", "<space>ws", telescope.lsp_workspace_symbols, { buffer = bufnr, desc = "Workspace symbols" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show documentation" })
