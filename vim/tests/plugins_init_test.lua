local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local plugins = require("plugins")

local T = new_set()

T["exports plugin specs used by lazy.nvim"] = function()
  eq(type(plugins), "table")
  eq(plugins[1][1], "masakiq/markdown-preview.nvim")

  local has_plenary = false
  local has_telescope_ui_select = false

  for _, spec in ipairs(plugins) do
    if spec[1] == "nvim-lua/plenary.nvim" then
      has_plenary = true
    end

    if spec[1] == "nvim-telescope/telescope-ui-select.nvim" then
      has_telescope_ui_select = true
    end
  end

  eq(has_plenary, true)
  eq(has_telescope_ui_select, true)
end

return T
