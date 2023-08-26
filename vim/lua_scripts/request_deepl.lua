local home = os.getenv("HOME")
local lua_script_path = home .. "/.vim/lua_scripts/"
local deepl_auth_key_file = os.getenv("DEEPL_AUTH_KEY_FILE_PATH")

local M = {}

function M.request_deepl(text, target_lang)
  local json = require "json"
  local read_file = dofile(lua_script_path .. "read_file.lua")
  local auth_key = read_file.read_file(deepl_auth_key_file)

  local data = Translate(auth_key, text, target_lang)
  local json_data = json:decode(data)
  if not json_data then
    error "data is empty"
  end
  if not json_data.translations then
    error "DeepL returns error"
  end
  return json_data.translations[1].text
end

function Translate(auth_key, text, target_lang)
  local curl_template = [[
  curl --silent -X POST 'https://api-free.deepl.com/v2/translate' \
  --header 'Authorization: DeepL-Auth-Key %s' \
  --header 'Content-Type: application/json' \
  --data '{
    "text": [ "%s" ],
    "target_lang": "%s"
  }'
  ]]
  local curl_command = string.format(
    curl_template,
    auth_key:gsub("\n", ""),
    text:gsub("\n", "\\n"),
    target_lang
  )
  local file = io.popen(curl_command, "r")

  if not file then
    print("file not found")
    return
  end

  local data = file:read("*all")
  file:close()

  return data;
end

return M
