local M = {}

function M.open_github(mode)
  local absolute_file_path = vim.api.nvim_exec("echo expand('%:p')", true)
  local github_url = RepositoryUrl()

  if mode == 'normal' then
    local win = 0
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line = cursor[1]

    github_url = github_url .. "/blob/" .. Commit() .. RelativeFilePath(absolute_file_path) .. '#L' .. line
  elseif mode == 'visual' then
    vim.cmd('normal! gv')
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")

    github_url = github_url ..
        "/blob/" .. Commit() .. RelativeFilePath(absolute_file_path) .. '#L' .. start_line .. '-L' .. end_line
  elseif mode == 'repo' then
    -- do nothing
  end

  os.execute("open " .. github_url)
end

function RepositoryUrl()
  local remote = io.popen("git remote get-url origin"):read("*all"):gsub("^%s*(.-)%s*$", "%1")
  local remote_url = remote:gsub("%.git$", "")

  if remote_url:find("^https://github.com") then return remote_url end
  if remote_url:find("^git@github.com") then return remote_url:gsub("^git@github.com:", "https://github.com/") end
  if remote_url:find("^ssh://git@github.com") then return remote_url:gsub("^ssh://git@github.com", "https://github.com") end
end

function Commit()
  return io.popen("git show -s --format=%H"):read("*all"):gsub("^%s*(.-)%s*$", "%1")
end

function RelativeFilePath(absolute_file_path)
  local repository_root_path = io.popen("git rev-parse --show-toplevel"):read("*all"):gsub("^%s*(.-)%s*$", "%1")
  repository_root_path = string.gsub(repository_root_path, '-', "%%-")
  return absolute_file_path:gsub(repository_root_path, "")
end

return M
