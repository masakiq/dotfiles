local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["file_operation.lua copies relative, ranged, and absolute paths"] = function()
  helpers.track_editor_state()

  local copied = {}
  local printed = {}

  helpers.stub(vim.fn, "expand", function(expr)
    if expr == "%" then
      return "vim/plugin/file_operation.lua"
    end

    if expr == "%:p" then
      return "/tmp/file_operation.lua"
    end

    return expr
  end)
  helpers.stub(vim.fn, "line", function(expr)
    if expr == "'<" then
      return 2
    end

    if expr == "'>" then
      return 4
    end

    if expr == "." then
      return 8
    end

    return 0
  end)
  helpers.stub(vim.fn, "visualmode", function()
    return ""
  end)
  helpers.stub(vim.fn, "setreg", function(register, value)
    copied[register] = value
  end)
  helpers.stub(_G, "print", function(message)
    table.insert(printed, message)
  end)

  local module = dofile("vim/plugin/file_operation.lua")

  module.copy_current_path()
  module.copy_current_path_with_line_number()
  module.copy_absolute_path()

  eq(vim.fn.exists(":CopyCurrentPath"), 2)
  eq(vim.fn.exists(":CopyCurrentPathWithLineNumber"), 2)
  eq(vim.fn.exists(":CopyAbsolutePath"), 2)
  eq(copied["+"], "/tmp/file_operation.lua")
  eq(printed, {
    "copied current path: vim/plugin/file_operation.lua",
    "copied current path: vim/plugin/file_operation.lua:2:3:4",
    "copied absolute path: /tmp/file_operation.lua",
  })
end

return T
