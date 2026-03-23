local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["tab_operation.lua registers tab commands and opens clipboard files in tabs"] = function()
  helpers.track_editor_state()

  local seen = {}

  helpers.stub(vim.fn, "getreg", function(register)
    eq(register, "+")
    return "README.md\nvim/init.lua"
  end)
  helpers.stub(vim, "cmd", function(command)
    table.insert(seen, command)
  end)

  dofile("vim/plugin/tab_operation.lua")
  vim.api.nvim_cmd({ cmd = "OpenFilesFromClipboard" }, {})

  eq(vim.fn.exists(":CloseTabsRight"), 2)
  eq(vim.fn.exists(":CloseTabsLeft"), 2)
  eq(vim.fn.exists(":CloseTabs"), 2)
  eq(vim.fn.exists(":MergeTab"), 2)
  eq(vim.fn.exists(":SeparateTab"), 2)
  eq(vim.fn.exists(":CopyAllTabPath"), 2)
  eq(vim.fn.exists(":OpenFilesFromClipboard"), 2)
  eq(vim.fn.exists(":CopyAllTabAbsolutePath"), 2)
  eq(vim.fn.maparg("<leader>m", "n", false, true).desc, "Merge Tab")
  eq(vim.fn.maparg("<leader>s", "n", false, true).desc, "Separate Tab")
  eq(seen, {
    "tab drop README.md",
    "tab drop vim/init.lua",
  })
end

return T
