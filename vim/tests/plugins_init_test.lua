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

T["vim-visual-multi spec restores legacy VM_maps during init"] = function()
  local visual_multi_spec

  for _, spec in ipairs(plugins) do
    if spec[1] == "mg979/vim-visual-multi" then
      visual_multi_spec = spec
      break
    end
  end

  eq(type(visual_multi_spec), "table")
  eq(type(visual_multi_spec.init), "function")

  local previous_maps = vim.g.VM_maps

  vim.g.VM_maps = nil
  visual_multi_spec.init()

  eq(vim.g.VM_maps, {
    Align = "<M-a>",
    Surround = "S",
    ["Case Conversion Menu"] = "C",
    ["Add Cursor Down"] = "<M-Down>",
    ["Add Cursor Up"] = "<M-Up>",
  })

  vim.g.VM_maps = previous_maps
end

return T
