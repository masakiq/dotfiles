local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["selectors.lua registers commands and mappings that forward to selector commands"] = function()
  helpers.track_editor_state({
    modules = { "commands.selectors" },
  })

  local calls = {}
  local visual_context = {
    mode = "x",
    text = "selected",
  }

  helpers.with_module_stubs({
    ["commands.selectors"] = {
      select_function = function()
        table.insert(calls, { "select_function" })
      end,
      select_visual_function = function(context)
        table.insert(calls, { "select_visual_function", context })
      end,
      capture_active_visual_context = function()
        return visual_context
      end,
    },
  }, function()
    dofile("vim/plugin/selectors.lua")
  end)

  vim.cmd("SelectFunction")
  vim.cmd("SelectVisualFunction")
  vim.cmd("SelectVidualFunction")
  vim.fn.maparg("<space><space>", "x", false, true).callback()

  eq(vim.fn.exists(":SelectFunction"), 2)
  eq(vim.fn.exists(":SelectVisualFunction"), 2)
  eq(vim.fn.exists(":SelectVidualFunction"), 2)
  eq(vim.fn.maparg("<space><space>", "n"), "<Cmd>SelectFunction<CR>")
  eq(calls, {
    { "select_function" },
    { "select_visual_function", nil },
    { "select_visual_function", nil },
    { "select_visual_function", visual_context },
  })
end

return T
