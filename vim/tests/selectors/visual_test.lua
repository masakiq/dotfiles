local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local visual = require("selectors.visual")

local T = new_set()

local function find_entry(label)
  for _, entry in ipairs(visual.entries) do
    if entry.label == label then
      return entry
    end
  end

  error("Entry not found: " .. label)
end

T["SnakeCase replaces selected text"] = function()
  local buf = helpers.make_scratch_buffer({ "UserName" })

  find_entry("SnakeCase").callback({
    bufnr = buf,
    start_line = 1,
    start_col = 1,
    end_line = 1,
    end_col = 8,
    text = "UserName",
  })

  eq(vim.api.nvim_buf_get_lines(buf, 0, -1, false), { "user_name" })
end

T["PascalCase replaces selected text"] = function()
  local buf = helpers.make_scratch_buffer({ "user_name" })

  find_entry("PascalCase").callback({
    bufnr = buf,
    start_line = 1,
    start_col = 1,
    end_line = 1,
    end_col = 9,
    text = "user_name",
  })

  eq(vim.api.nvim_buf_get_lines(buf, 0, -1, false), { "UserName" })
end

T["warns when multiple lines are selected"] = function()
  local buf = helpers.make_scratch_buffer({ "UserName", "OtherName" })
  local notifications = helpers.track_notify()

  find_entry("SnakeCase").callback({
    bufnr = buf,
    start_line = 1,
    start_col = 1,
    end_line = 2,
    end_col = 5,
    text = "UserName\nOther",
  })

  eq(vim.api.nvim_buf_get_lines(buf, 0, -1, false), { "UserName", "OtherName" })
  eq(notifications[1].message, "Multiple line selection is not supported.")
  eq(notifications[1].level, vim.log.levels.WARN)
end

T["CopyCurrentPathWithLineNumber writes path and lines into clipboard register"] = function()
  local path = vim.fn.tempname() .. ".lua"
  local buf = helpers.make_scratch_buffer({ "aaa", "bbb", "ccc" }, path)
  local original_expand = vim.fn.expand
  local original_print = print
  local original_setreg = vim.fn.setreg
  local captured_register

  vim.fn.expand = function()
    return path
  end
  vim.fn.setreg = function(_, value)
    captured_register = value
  end
  _G.print = function() end

  MiniTest.finally(function()
    vim.fn.expand = original_expand
    vim.fn.setreg = original_setreg
    _G.print = original_print
  end)

  find_entry("CopyCurrentPathWithLineNumber").callback({
    bufnr = buf,
    start_line = 2,
    start_col = 1,
    end_line = 3,
    end_col = 3,
    text = "bbb\nccc",
  })

  eq(captured_register, path .. ":2:3")
end

return T
