local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["easymotion.lua configures smartcase and the over-window f mapping"] = function()
  helpers.track_editor_state({
    globals = { "EasyMotion_smartcase" },
  })

  dofile("vim/plugin/easymotion.lua")

  eq(vim.g.EasyMotion_smartcase, 1)
  eq(vim.fn.maparg("f", "n"), "<Plug>(easymotion-overwin-f2)")
end

return T
