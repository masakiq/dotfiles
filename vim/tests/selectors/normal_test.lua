local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local normal = require("selectors.normal")

local T = new_set()

T["entries expose stable label/command pairs"] = function()
  eq(#normal.entries, 33)
  eq(normal.entries[1], { label = "OpenAllFiles", command = "OpenAllFiles" })
  eq(normal.entries[#normal.entries], { label = "StripAnsi", command = "StripAnsi" })

  for _, entry in ipairs(normal.entries) do
    eq(type(entry.label), "string")
    eq(type(entry.command), "string")
  end
end

return T
