local host = "localhost"
local base_port = 8765
local previewed_files = {}

local function is_swagger_command_available()
  local handle = io.popen("command -v swagger-ui-watcher >/dev/null 2>&1 && echo 'yes' || echo 'no'")
  local result = handle:read("*a")
  handle:close()
  if result:match("yes") ~= nil then
    return true
  end

  vim.api.nvim_echo(
    {
      {
        "Command `swagger-ui-watcher` not found. Please execute `npm install -g swagger-ui-watcher`",
        "WarningMsg"
      }
    },
    true,
    {}
  )
  return false
end

local function extract_max_port()
  local max_port = base_port
  for _, v in pairs(previewed_files) do
    if v['port'] then
      if not max_port or v['port'] > max_port then
        max_port = v['port']
      end
    end
  end
  return max_port
end

local function stop_server()
  if not is_swagger_command_available() then return end

  local swagger_path = vim.fn.expand("%:p")

  if not previewed_files[swagger_path] then
    return
  end
  vim.fn.jobstop(previewed_files[swagger_path]['job_pid'])
  previewed_files[swagger_path] = nil
end

local function start_server()
  if not is_swagger_command_available() then return end

  local swagger_path = vim.fn.expand("%:p")

  if previewed_files[swagger_path] then
    os.execute("open http://" .. host .. ":" .. previewed_files[swagger_path]['port'])
    return
  end
  previewed_files[swagger_path] = {}

  local port = extract_max_port() + 1
  previewed_files[swagger_path]['port'] = port
  local cmd = "swagger-ui-watcher -p " .. port .. " -h " .. host .. " " .. swagger_path

  previewed_files[swagger_path]['job_pid'] = vim.fn.jobstart(cmd, {
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
end

vim.api.nvim_create_user_command("SwaggerPreview", start_server, {})
vim.api.nvim_create_user_command("SwaggerPreviewStop", stop_server, {})
