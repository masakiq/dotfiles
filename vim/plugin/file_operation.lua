local M = {}

function M.copy_current_path()
  vim.cmd("cd .")
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  print("copied current path: " .. path)
end

function M.copy_current_path_with_line_number()
  local path = vim.fn.expand("%")

  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  if start_line ~= end_line or vim.fn.visualmode() ~= "" then
    local lines = {}
    for i = start_line, end_line do
      table.insert(lines, tostring(i))
    end
    local line_path = path .. ":" .. table.concat(lines, ":")
    vim.fn.setreg("+", line_path)
    print("copied current path: " .. line_path)
  else
    local line_path = path .. ":" .. vim.fn.line(".")
    vim.fn.setreg("+", line_path)
    print("copied current path: " .. line_path)
  end
end

function M.copy_absolute_path()
  local abs_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", abs_path)
  print("copied absolute path: " .. abs_path)
end

vim.api.nvim_create_user_command("CopyCurrentPath", M.copy_current_path, {})
vim.api.nvim_create_user_command("CopyCurrentPathWithLineNumber", M.copy_current_path_with_line_number, {})
vim.api.nvim_create_user_command("CopyAbsolutePath", M.copy_absolute_path, {})

return M
