local home = os.getenv("HOME")
local lua_script_path = home .. "/.vim/lua_scripts/"
local deepl_input_path = home .. "/.vim/deepl/input.txt"
local deepl_output_path = home .. "/.vim/deepl/output.txt"
local deepl_target_lang = home .. "/.vim/deepl/target_lang"

local M = {}

function M.translate()
  local read_file = dofile(lua_script_path .. "read_file.lua")
  local write_file = dofile(lua_script_path .. "write_file.lua")
  local request_deepl = dofile(lua_script_path .. "request_deepl.lua")

  local text = read_file.read_file(deepl_input_path)
  local target_lang = read_file.read_file(deepl_target_lang)
  target_lang = target_lang or "en"
  target_lang = target_lang:gsub("\n", "")

  local translated_text = request_deepl.request_deepl(text, target_lang)
  write_file.write_file(deepl_output_path, translated_text)
  vim.cmd("silent! exec 'checktime'")
end

return M
