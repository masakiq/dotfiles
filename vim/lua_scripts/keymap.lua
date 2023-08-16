local home = os.getenv("HOME")
local lua_script_path = home .. "/.vim/lua_scripts/"

local cloud_note_root = os.getenv("CLOUD_NOTE_ROOT")
local cheat_sheets_path = cloud_note_root .. "/cheat_sheets"

local local_note_root = os.getenv("LOCAL_NOTE_ROOT")

vim.api.nvim_set_keymap(
  "n",
  "<space>/",
  "<cmd>lua dofile('" .. lua_script_path .. "search_word.lua').search_word()<CR>",
  { noremap = true, silent = false }
)

vim.api.nvim_set_keymap(
  "n",
  "<space>on",
  "<cmd>lua dofile('" .. lua_script_path .. "search_word.lua').search_word('" .. local_note_root .. "')<CR>",
  { noremap = true, silent = false }
)

vim.api.nvim_set_keymap(
  "n",
  "<space>oc",
  "<cmd>lua dofile('" .. lua_script_path .. "search_word.lua').search_word('" .. cheat_sheets_path .. "')<CR>",
  { noremap = true, silent = false }
)

vim.api.nvim_set_keymap(
  "n",
  "<Leader>t",
  "<cmd>lua dofile('" .. lua_script_path .. "translate.lua').translate()<CR>",
  { noremap = true, silent = false }
)

vim.api.nvim_set_keymap(
  "n",
  "<Leader>s",
  "<cmd>lua dofile('" .. lua_script_path .. "change_translate_language.lua').change_translate_language()<CR>",
  { noremap = true, silent = false }
)
