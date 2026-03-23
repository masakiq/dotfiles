local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["legacy_commands.lua wipes hidden buffers and registers helper commands"] = function()
  helpers.track_editor_state()

  local visible = helpers.make_scratch_buffer({ "visible" }, "visible.txt")
  local hidden = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_lines(hidden, 0, -1, false, { "hidden" })
  vim.api.nvim_buf_set_name(hidden, "hidden.txt")

  MiniTest.finally(function()
    if vim.api.nvim_buf_is_valid(hidden) then
      pcall(vim.api.nvim_buf_delete, hidden, { force = true })
    end
  end)

  vim.api.nvim_set_current_buf(visible)

  local module = dofile("vim/plugin/legacy_commands.lua")
  module.delete_bufs_without_existing_windows()

  eq(vim.api.nvim_buf_is_valid(visible), true)
  eq(vim.api.nvim_buf_is_valid(hidden), false)
  eq(vim.fn.exists(":LoadVIMRC"), 2)
  eq(vim.fn.exists(":Reload"), 2)
  eq(vim.fn.exists(":QuitAll"), 2)
  eq(vim.fn.exists(":DeleteBuffers"), 2)
  eq(vim.fn.exists(":StartCopyStatusMessages"), 2)
  eq(vim.fn.exists(":FinishCopyStatusMessages"), 2)
end

return T
