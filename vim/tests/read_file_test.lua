local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local read_file = require("read_file")

local T = new_set()

T["read_file() returns file contents"] = function()
  local path = vim.fn.tempname()
  local handle = assert(io.open(path, "w"))

  handle:write("hello\nworld")
  handle:close()

  MiniTest.finally(function()
    os.remove(path)
  end)

  eq(read_file.read_file(path), "hello\nworld")
end

T["read_file() prints error and returns nil for missing file"] = function()
  local printed = {}
  local original_print = print

  _G.print = function(...)
    table.insert(printed, table.concat(vim.tbl_map(tostring, { ... }), " "))
  end

  MiniTest.finally(function()
    _G.print = original_print
  end)

  local result = read_file.read_file(vim.fn.tempname() .. "/missing.txt")

  eq(result, nil)
  helpers.expect.match(printed[1], "^error:")
end

return T
