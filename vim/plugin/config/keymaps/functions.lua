local search_word = require("search_word")

local cloud_note_root = os.getenv("CLOUD_NOTE_ROOT")
local cheat_sheets_path = cloud_note_root .. "/cheat_sheets"

local local_note_root = os.getenv("LOCAL_NOTE_ROOT")

vim.keymap.set("n", "<space>/", function()
  search_word.search_word()
end, { silent = false })

vim.keymap.set("n", "<space>on", function()
  search_word.search_word(local_note_root, "--sort path")
end, { silent = false })

vim.keymap.set("n", "<space>oc", function()
  search_word.search_word(cheat_sheets_path)
end, { silent = false })

vim.keymap.set("n", "<space>ov", function()
  os.execute("code " .. vim.api.nvim_buf_get_name(0))
end, { silent = false })
