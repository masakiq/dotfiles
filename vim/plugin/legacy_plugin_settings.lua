vim.g.dart_html_in_string = true
vim.g.dart_style_guide = 2

vim.g.tabline_charmax = 40

vim.g.move_map_keys = 0
vim.g.move_past_end_of_line = 0
vim.keymap.set("n", "<M-j>", "<Plug>MoveLineDown")
vim.keymap.set("n", "<M-k>", "<Plug>MoveLineUp")
vim.keymap.set("v", "<M-j>", "<Plug>MoveBlockDown")
vim.keymap.set("v", "<M-k>", "<Plug>MoveBlockUp")
vim.keymap.set("v", "<M-h>", "<Plug>MoveBlockLeft")
vim.keymap.set("v", "<M-l>", "<Plug>MoveBlockRight")

vim.g.html_indent_script1 = "inc"
vim.g.html_indent_style1 = "inc"

vim.keymap.set("n", "<leader>c", "<cmd>Commentary<CR>", {
  desc = "Commentary",
  silent = true,
})
vim.keymap.set("x", "<leader>c", "<Plug>Commentary", {
  desc = "Commentary",
  remap = true,
  silent = true,
})

vim.g.vim_markdown_folding_disabled = 0
vim.g.vim_markdown_folding_level = 4
