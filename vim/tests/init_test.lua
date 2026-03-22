local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_case = child.setup,
    post_once = child.stop,
  },
})

T["loads startup options and calls config.lazy.setup()"] = function()
  child.lua([[
    _G.init_setup_calls = 0
    package.loaded["config.lazy"] = {
      setup = function()
        _G.init_setup_calls = _G.init_setup_calls + 1
      end,
    }

    dofile("vim/init.lua")
  ]])

  eq(child.g.mapleader, ",")
  eq(child.o.timeout, true)
  eq(child.o.timeoutlen, 300)
  eq(child.o.ttimeoutlen, 500)
  eq(child.o.exrc, true)
  eq(child.o.secure, true)
  eq(child.lua_get("_G.init_setup_calls"), 1)
end

return T
