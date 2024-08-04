local port = 8765
local host = "localhost"
local file_being_previewed = nil
local server_pid = nil

local function command_exists(cmd)
  local handle = io.popen("command -v swagger-ui-watcher >/dev/null 2>&1 && echo 'yes' || echo 'no'")
  local result = handle:read("*a")
  handle:close()
  if result:match("yes") ~= nil then
    return true
  end

  vim.api.nvim_echo(
    { { "Command `swagger-ui-watcher` not found. Please execute `npm install -g swagger-ui-watcher`", "WarningMsg" } },
    true, {})
  return false
end

local function stop_server()
  if not command_exists() then return end

  vim.fn.jobstop(server_pid)
  file_being_previewed = nil
  server_pid = nil
end

local function start_server()
  if not command_exists() then return end

  local swagger_path = vim.fn.expand("%:p")

  if swagger_path == file_being_previewed then
    os.execute("open http://" .. host .. ":" .. port)
    return
  end

  if file_being_previewed ~= nil then
    stop_server()
  end

  local cmd = "swagger-ui-watcher -p " .. port .. " -h " .. host .. " " .. swagger_path

  server_pid = vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      print(vim.inspect(data))
    end,
    on_stderr = function(_, data, _)
      print(vim.inspect(data))
    end,
    on_exit = function(_, code, _)
      print("swagger-ui-watcher exited with code " .. code)
    end,
  })
  file_being_previewed = swagger_path
end


vim.api.nvim_create_user_command("SwaggerPreview", start_server, {})
vim.api.nvim_create_user_command("SwaggerPreviewStop", stop_server, {})
