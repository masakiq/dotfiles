if vim.fn.has("gui_running") == 1 then
  return
end

if vim.g.dotfiles_which_key_registered then
  return
end

vim.g.which_key_map = {
  q = "Quit",
  w = "Save",
  i = "Toggle hlsearch",
  h = "Move left",
  j = "Move down",
  k = "Move up",
  l = "Move right",
  t = "Tab new",
  a = "Toggle QuickFix",
  m = "Copy last messages",
  ["/"] = "Search Word or Open File",
  ["."] = "Spread horizontally right",
  [","] = "Spread horizontally left",
  ["="] = "Spread vertically top",
  ["-"] = "Spread vertically bottom",
  ["<Right>"] = "Expand right",
  ["<Left>"] = "Expand left",
  ["<Up>"] = "Expand up",
  ["<Down>"] = "Expand down",
}

vim.g.which_key_use_floating_win = 1

vim.keymap.set("n", "<space>", "<cmd>WhichKey '<space>'<CR>", { silent = true })
vim.keymap.set("n", "<leader>", "<cmd>WhichKey '<leader>'<CR>", { silent = true })
vim.keymap.set("x", "<space>", ":<C-u>WhichKeyVisual '<space>'<CR>", { silent = true })
vim.keymap.set("x", "<leader>", ":<C-u>WhichKeyVisual '<leader>'<CR>", { silent = true })

vim.api.nvim_set_hl(0, "WhichKeyFloating", { ctermbg = 232 })

local which_key_group = vim.api.nvim_create_augroup("WhichKeyColors", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = which_key_group,
  pattern = "which_key",
  callback = function()
    vim.api.nvim_set_hl(0, "WhichKey", { ctermfg = 13 })
    vim.api.nvim_set_hl(0, "WhichKeySeperator", { ctermfg = 14 })
    vim.api.nvim_set_hl(0, "WhichKeyGroup", { ctermfg = 11 })
    vim.api.nvim_set_hl(0, "WhichKeyDesc", { ctermfg = 10 })
  end,
})

local ok_space = pcall(vim.fn["which_key#register"], "<space>", "g:which_key_map")
local ok_leader = pcall(vim.fn["which_key#register"], "<leader>", "g:which_key_map")

if ok_space and ok_leader then
  vim.g.dotfiles_which_key_registered = true
end
