local M = {}

local function list_tabs()
  local list = {}
  local tabnumber = 1

  while tabnumber <= vim.fn.tabpagenr("$") do
    local buflist = vim.fn.tabpagebuflist(tabnumber)
    for _, buf in ipairs(buflist) do
      local file = vim.fn.expandcmd("#" .. buf)
      file = string.gsub(file, "#.*", "[No-Name]")
      table.insert(list, file)
    end
    tabnumber = tabnumber + 1
  end

  return list
end

local function diff_files(line)
  vim.cmd("vertical diffsplit " .. line)
  vim.wo.wrap = true
  vim.cmd("wincmd h")
  vim.wo.wrap = true
end

local function get_current_branch()
  local handle = io.popen("git branch --show-current 2>/dev/null")
  if handle then
    local result = handle:read("*a"):gsub("\n", "")
    handle:close()
    return result
  end
  return "main"
end

local function select_diff_files(branch)
  local current_branch = get_current_branch()
  vim.g.selected_branch = branch
  local ok, _ = pcall(function()
    vim.cmd("Gvdiff " .. vim.g.selected_branch .. "..." .. current_branch)
    vim.cmd("SwapWindow")
  end)
  if not ok then
    vim.api.nvim_echo({ { vim.v.exception, "WarningMsg" } }, true, {})
  end
end

function M.diff_file()
  local ok, _ = pcall(function()
    vim.fn["fzf#run"](vim.fn["fzf#wrap"]({
      source = list_tabs(),
      sink = diff_files,
      window = { width = 0.9, height = 0.9, xoffset = 0.5, yoffset = 0.5 },
    }))
  end)
  if not ok then
    vim.api.nvim_echo({ { vim.v.exception, "WarningMsg" } }, true, {})
  end
end

vim.api.nvim_create_user_command("DiffFile", M.diff_file, {})

return M
