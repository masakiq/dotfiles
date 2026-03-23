local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["ClearAllBuffers clears each visible file buffer and keeps focus"] = function()
  helpers.track_editor_state()

  dofile("vim/plugin/buffer_operation.lua")

  local root = vim.fn.tempname()
  local file1 = root .. "-one.txt"
  local file2 = root .. "-two.txt"

  vim.fn.writefile({ "alpha" }, file1)
  vim.fn.writefile({ "beta" }, file2)

  vim.cmd("edit " .. vim.fn.fnameescape(file1))
  local left_win = vim.api.nvim_get_current_win()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "left" })
  vim.cmd("write")

  vim.cmd("vsplit " .. vim.fn.fnameescape(file2))
  local right_win = vim.api.nvim_get_current_win()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "right" })
  vim.cmd("write")

  vim.cmd("wincmd h")
  local current_buf = vim.api.nvim_get_current_buf()
  vim.cmd("ClearAllBuffers")

  eq(vim.fn.exists(":ClearAllBuffers"), 2)
  eq(vim.api.nvim_get_current_buf(), current_buf)
  eq(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(left_win), 0, -1, false), { "" })
  eq(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(right_win), 0, -1, false), { "" })
end

return T
