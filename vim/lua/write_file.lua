local M = {}

function M.write_file(path, text)
  local file, err = io.open(path, "w")

  if err then
    print("error: " .. err)
    return
  end

  if not file then
    print("file not found")
    return
  end

  file:write(text)
  file:close()
end

return M
