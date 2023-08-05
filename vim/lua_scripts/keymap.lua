local home = os.getenv("HOME")
local lua_script_path = home .. "/.vim/lua_scripts/"

local cloud_note_root = os.getenv("CLOUD_NOTE_ROOT")
local cheat_sheets_path = cloud_note_root .. "/cheat_sheets"

vim.api.nvim_set_keymap(
  "n",
  "<space>/",
  "<cmd>lua dofile('" .. lua_script_path .. "search_word.lua').search_word()<CR>",
  { noremap = true, silent = false }
)

vim.api.nvim_set_keymap(
  "n",
  "<Leader>a",
  "<cmd>lua dofile('" .. lua_script_path .. "search_word.lua').search_word('" .. cheat_sheets_path .. "')<CR>",
  { noremap = true, silent = false }
)
