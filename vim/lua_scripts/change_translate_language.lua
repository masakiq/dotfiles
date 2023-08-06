local home = os.getenv("HOME")
local lua_script_path = home .. "/.vim/lua_scripts/"
local deepl_target_lang = home .. "/.vim/deepl/target_lang"

local M = {}

function M.change_translate_language()
  local Menu = require("nui.menu")
  local event = require("nui.utils.autocmd").event

  local menu = Menu({
    position = {
      row = '30%',
      col = '50%',
    },
    size = {
      width = 25,
      height = 5,
    },
    border = {
      style = "single",
      text = {
        top = "[Choose Deepl Target Language]",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = {
      Menu.item("en"),
      Menu.item("ja"),
    },
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function()
      print("Menu Closed!")
    end,
    on_submit = function(item)
      local write_file = dofile(lua_script_path .. "write_file.lua")
      write_file.write_file(deepl_target_lang, item.text)
      print("Changed DeepL Target Language : ", item.text)
    end,
  })

  -- mount the component
  menu:mount()

  -- unmount component when escape is pressed
  menu:map("n", "<Esc>", function()
    menu:unmount()
  end, { noremap = true })

  menu:map("i", "<Esc>", function()
    menu:unmount()
  end, { noremap = true })
end

return M
