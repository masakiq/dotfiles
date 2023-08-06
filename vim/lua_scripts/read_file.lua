local M = {}

function M.read_file(path)
  local file, err = io.open(path, "r")

  if err then
    print("error: " .. err)
    return
  end

  if not file then
    print("file not found")
    return
  end

  local content = file:read("*a")
  file:close()
  return content
end

return M
