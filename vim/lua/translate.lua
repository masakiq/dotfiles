local home = os.getenv("HOME")
local lua_script_path = home .. "/.vim/lua_scripts/"
local deepl_input_path = home .. "/.vim/deepl/input.txt"
local deepl_output_path = home .. "/.vim/deepl/output.txt"

local M = {}

function M.translate()
  local Menu = require("nui.menu")

  local menu = Menu({
    position = {
      row = '30%',
      col = '50%',
    },
    size = {
      width = 15,
      height = 3,
    },
    border = {
      style = "double",
      text = {
        top = "[Translate]",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = {
      Menu.item('en'),
      Menu.item('ja'),
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
      Translate(item.text)
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

  menu:map("n", "<C-c>", function()
    menu:unmount()
  end, { noremap = true })

  menu:map("i", "<C-c>", function()
    menu:unmount()
  end, { noremap = true })
end

function Translate(target_lang)
  local read_file = dofile(lua_script_path .. "read_file.lua")
  local write_file = dofile(lua_script_path .. "write_file.lua")
  local request_deepl = dofile(lua_script_path .. "request_deepl.lua")

  local text = read_file.read_file(deepl_input_path)

  local translated_text = request_deepl.request_deepl(text, target_lang)
  write_file.write_file(deepl_output_path, translated_text)
  vim.cmd("silent! exec 'checktime'")
end

return M
