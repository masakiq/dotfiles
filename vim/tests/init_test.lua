local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["loads startup options and calls config.lazy.setup()"] = function()
  helpers.track_editor_state({
    options = { "timeout", "timeoutlen", "ttimeoutlen", "exrc", "secure" },
    globals = { "mapleader" },
    modules = { "config.lazy" },
  })

  local setup_calls = 0

  helpers.with_module_stubs({
    ["config.lazy"] = {
      setup = function()
        setup_calls = setup_calls + 1
      end,
    },
  }, function()
    dofile("vim/init.lua")
  end)

  eq(vim.g.mapleader, ",")
  eq(vim.o.timeout, true)
  eq(vim.o.timeoutlen, 300)
  eq(vim.o.ttimeoutlen, 500)
  eq(vim.o.exrc, true)
  eq(vim.o.secure, true)
  eq(setup_calls, 1)
end

return T
