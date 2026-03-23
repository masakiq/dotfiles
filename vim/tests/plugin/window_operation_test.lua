local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["window_operation.lua swaps adjacent windows"] = function()
  helpers.track_editor_state()

  local seen = {}

  dofile("vim/plugin/window_operation.lua")
  helpers.stub(vim, "cmd", function(command)
    table.insert(seen, command)
  end)

  vim.api.nvim_cmd({ cmd = "SwapWindow" }, {})
  vim.fn.maparg("<leader>w", "n", false, true).callback()

  eq(vim.fn.exists(":SwapWindow"), 2)
  eq(vim.fn.maparg("<leader>w", "n", false, true).desc, "Swap Window")
  eq(seen, {
    'silent! exec "normal! \\<C-w>x"',
    'silent! exec "normal! \\<C-w>x"',
  })
end

return T
