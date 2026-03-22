local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local write_file = require("write_file")

local T = new_set()

T["write_file() writes text to disk"] = function()
  local path = vim.fn.tempname()

  MiniTest.finally(function()
    os.remove(path)
  end)

  write_file.write_file(path, "updated text")

  local handle = assert(io.open(path, "r"))
  local content = handle:read("*a")
  handle:close()

  eq(content, "updated text")
end

T["write_file() prints error for missing parent directory"] = function()
  local printed = {}
  local original_print = print

  _G.print = function(...)
    table.insert(printed, table.concat(vim.tbl_map(tostring, { ... }), " "))
  end

  MiniTest.finally(function()
    _G.print = original_print
  end)

  write_file.write_file(vim.fn.tempname() .. "/missing/file.txt", "updated text")

  helpers.expect.match(printed[1], "^error:")
end

return T
