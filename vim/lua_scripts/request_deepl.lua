local home = os.getenv("HOME")
local lua_script_path = home .. "/.vim/lua_scripts/"
local deepl_auth_key_file = os.getenv("DEEPL_AUTH_KEY_FILE_PATH")

local M = {}

function M.request_deepl(text, target_lang)
  local json = require "json"
  local read_file = dofile(lua_script_path .. "read_file.lua")
  local auth_key = read_file.read_file(deepl_auth_key_file):gsub("\n", "")

  local data = RequestDeepL(auth_key, text, target_lang)
  return data
end

function RequestDeepL(auth_key, text, target_lang)
  local json = require "json"
  local inspect = require "inspect"

  local curl_template = [[
  curl -s -w "\n%s\n" -X POST 'https://api-free.deepl.com/v2/translate' \
  --header 'Authorization: DeepL-Auth-Key %s' \
  --header 'Content-Type: application/json' \
  --data '{
    "text": [ "%s" ],
    "target_lang": "%s"
  }'
  ]]

  text = text:gsub("\n", "\\n")
  text = text:gsub("\"", "\\\"")
  text = text:gsub("'", "\\\"")

  local curl_command = string.format(
    curl_template,
    "%{http_code}",
    auth_key,
    text,
    target_lang
  )
  local file = io.popen(curl_command, "r")

  if not file then
    error "DeepL returns empty!"
  end

  local data = file:read("*all")
  file:close()
  local body, code = string.match(data, "^(.-)\n(.*)$")
  code = code:gsub("\n", "")

  if code ~= "200" then
    error("DeepL returns error! code:" .. code .. ", body:" .. inspect(body))
  end

  local json_body = json:decode(body)
  if not json_body then
    error "DeepL returns empty body!"
  end

  if not json_body.translations then
    error("DeepL did not return any translation results! body:" .. inspect(json_body))
  end

  return json_body.translations[1].text;
end

return M
