if type(vim.g.which_key_map) ~= "table" then
  return
end

if vim.g.dotfiles_which_key_registered then
  return
end

local ok_space = pcall(vim.fn["which_key#register"], "<space>", "g:which_key_map")
local ok_leader = pcall(vim.fn["which_key#register"], "<leader>", "g:which_key_map")

if ok_space and ok_leader then
  vim.g.dotfiles_which_key_registered = true
end
