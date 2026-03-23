local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["tmux.lua registers mode switching mappings"] = function()
  helpers.track_editor_state()

  local original_term = vim.env.TERM
  local calls = {}

  MiniTest.finally(function()
    vim.env.TERM = original_term
  end)

  vim.env.TERM = "screen-256color"

  helpers.stub(vim.fn, "system", function(command)
    table.insert(calls, command)
    return ""
  end)

  dofile("vim/plugin/tmux.lua")

  vim.fn.maparg("<leader>v", "n", false, true).callback()
  vim.fn.maparg("<leader>t", "n", false, true).callback()
  vim.fn.maparg("<leader>a", "n", false, true).callback()

  eq(vim.fn.maparg("<leader>v", "n", false, true).desc, "Switch to vim mode")
  eq(vim.fn.maparg("<leader>t", "n", false, true).desc, "Switch to test mode")
  eq(vim.fn.maparg("<leader>a", "n", false, true).desc, "Switch to ai mode")
  eq(calls, {
    "mode_vim",
    "mode_test",
    "mode_ai",
  })
end

return T
