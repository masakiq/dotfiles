local function clear_all_buffers()
  if not vim.bo.modifiable then
    print("Buffer is not modifiable")
    return
  end

  local current_win = vim.fn.winnr()

  for win = 1, vim.fn.winnr("$") do
    vim.cmd(win .. "wincmd w")
    vim.cmd("%delete _")
    vim.cmd("write")
  end

  vim.cmd(current_win .. "wincmd w")
end

vim.api.nvim_create_user_command("ClearAllBuffers", clear_all_buffers, {})
