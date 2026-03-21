local M = {}

local function list_buf_nums()
  local buffers = {}

  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      table.insert(buffers, vim.api.nvim_win_get_buf(win))
    end
  end

  return buffers
end

local function list_all_buf_nums()
  local buffers = {}

  for _, info in ipairs(vim.fn.getbufinfo()) do
    table.insert(buffers, info.bufnr)
  end

  return buffers
end

function M.delete_bufs_without_existing_windows()
  local visible = {}
  for _, bufnr in ipairs(list_buf_nums()) do
    visible[bufnr] = true
  end

  for _, bufnr in ipairs(list_all_buf_nums()) do
    if not visible[bufnr] then
      pcall(vim.cmd, "bwipeout! " .. bufnr)
    end
  end
end

function M.delete_buffers()
  for _, bufnr in ipairs(list_all_buf_nums()) do
    pcall(vim.cmd, "bwipeout! " .. bufnr)
  end
end

local function load_vimrc()
  vim.cmd("source $MYVIMRC")
  vim.cmd("noh")
end

local function reload()
  vim.cmd("silent! checktime")
end

local function quit_all()
  M.delete_bufs_without_existing_windows()
  M.delete_buffers()
  vim.cmd("normal ZQ")
end

local function start_copy_status_messages()
  vim.cmd("redir @+")
end

local function finish_copy_status_messages()
  vim.cmd("redir END")
end

vim.api.nvim_create_user_command("LoadVIMRC", load_vimrc, {})
vim.api.nvim_create_user_command("Reload", reload, {})
vim.api.nvim_create_user_command("QuitAll", quit_all, {})
vim.api.nvim_create_user_command("DeleteBuffers", M.delete_buffers, {})
vim.api.nvim_create_user_command("StartCopyStatusMessages", start_copy_status_messages, { bang = true })
vim.api.nvim_create_user_command("FinishCopyStatusMessages", finish_copy_status_messages, { bang = true })

return M
