vim.g.dart_html_in_string = true
vim.g.dart_style_guide = 2

vim.g.VM_maps = {
  Align = "<M-a>",
  Surround = "S",
  ["Case Conversion Menu"] = "C",
  ["Add Cursor Down"] = "<M-Down>",
  ["Add Cursor Up"] = "<M-Up>",
}

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

vim.keymap.set("n", "<leader>c", "<cmd>Commentary<CR>", { silent = true })

vim.g.vim_markdown_folding_disabled = 0
vim.g.vim_markdown_folding_level = 4
