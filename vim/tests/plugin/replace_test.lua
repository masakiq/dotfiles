local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

local function set_selection(start_col, end_col)
  vim.fn.setpos("'<", { 0, 1, start_col, 0 })
  vim.fn.setpos("'>", { 0, 1, end_col, 0 })
end

T["replace.lua converts selections between PascalCase and snake_case"] = function()
  helpers.track_editor_state()

  helpers.make_scratch_buffer({ "PascalCase snake_case" }, "replace.txt")
  dofile("vim/plugin/replace.lua")

  set_selection(1, 10)
  vim.cmd("SnakeCase")
  eq(vim.api.nvim_get_current_line(), "pascal_case snake_case")

  set_selection(13, 22)
  vim.cmd("PascalCase")
  eq(vim.api.nvim_get_current_line(), "pascal_case SnakeCase")

  eq(vim.fn.exists(":SnakeCase"), 2)
  eq(vim.fn.exists(":PascalCase"), 2)
  eq(vim.fn.exists(":RemoveUnderBar"), 2)
  eq(vim.fn.exists(":AddUnderBar"), 2)
  eq(vim.fn.exists(":StripAnsi"), 2)
end

T["replace.lua strips ANSI escape sequences from the buffer"] = function()
  helpers.track_editor_state()

  local esc = string.char(27)
  helpers.make_scratch_buffer({
    esc .. "[31merror" .. esc .. "[0m",
    "plain",
  }, "ansi.txt")

  dofile("vim/plugin/replace.lua")
  vim.cmd("StripAnsi")

  eq(vim.api.nvim_buf_get_lines(0, 0, -1, false), {
    "error",
    "plain",
  })
end

return T
