local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local rubocop = require("rubocop")

local T = new_set()

local ns = vim.api.nvim_create_namespace("tests-rubocop")

local function set_diagnostics(buf, diagnostics)
  vim.diagnostic.set(ns, buf, diagnostics, {})
  MiniTest.finally(function()
    pcall(vim.diagnostic.reset, ns, buf)
  end)
end

local function stub_ui_select(handler)
  local original = vim.ui.select

  vim.ui.select = handler

  MiniTest.finally(function()
    vim.ui.select = original
  end)
end

T["disable_current_line_cops() sorts unique offenses and appends disable comment"] = function()
  local buf = helpers.make_scratch_buffer({ "puts :hello" })
  local notifications = helpers.track_notify()
  local seen_items
  local seen_format

  set_diagnostics(buf, {
    {
      lnum = 0,
      col = 0,
      message = "Use single quotes [Style/StringLiterals]",
      source = "RuboCop",
    },
    {
      lnum = 0,
      col = 2,
      message = "Use single quotes [Style/StringLiterals]",
      source = "rubocop",
    },
    {
      lnum = 0,
      col = 5,
      message = "Style/UnlessElse: Prefer `unless`.",
      source = "ruby-lsp",
      code = "Style/UnlessElse",
    },
  })

  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  stub_ui_select(function(items, opts, on_choice)
    seen_items = items
    seen_format = opts.format_item(items[2])
    on_choice(items[2])
  end)

  rubocop.disable_current_line_cops()

  eq(#seen_items, 2)
  eq(seen_items[1].cop, "Style/StringLiterals")
  eq(seen_items[2].cop, "Style/UnlessElse")
  eq(seen_format, "Style/UnlessElse: Prefer `unless`.")
  eq(vim.api.nvim_get_current_line(), "puts :hello # rubocop:disable Style/UnlessElse")
  eq(notifications[#notifications].message, "Added rubocop:disable for Style/UnlessElse")
  eq(notifications[#notifications].level, vim.log.levels.INFO)
end

T["disable_current_line_cops() reports already-disabled cops without mutating buffer"] = function()
  local buf = helpers.make_scratch_buffer({ "puts :hello # rubocop:disable Style/StringLiterals" })
  local notifications = helpers.track_notify()

  set_diagnostics(buf, {
    {
      lnum = 0,
      col = 0,
      message = "Use single quotes [Style/StringLiterals]",
      source = "RuboCop",
    },
  })

  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  stub_ui_select(function(items, _, on_choice)
    on_choice(items[1])
  end)

  rubocop.disable_current_line_cops()

  eq(vim.api.nvim_get_current_line(), "puts :hello # rubocop:disable Style/StringLiterals")
  eq(notifications[#notifications].message, "Current line already disables Style/StringLiterals.")
  eq(notifications[#notifications].level, vim.log.levels.INFO)
end

T["disable_current_line_cops() warns when current line has no RuboCop diagnostics"] = function()
  local buf = helpers.make_scratch_buffer({ "puts :hello" })
  local notifications = helpers.track_notify()

  set_diagnostics(buf, {
    {
      lnum = 0,
      col = 0,
      message = "Some other diagnostic",
      source = "tsserver",
    },
  })

  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  stub_ui_select(function()
    error("vim.ui.select should not be called")
  end)

  rubocop.disable_current_line_cops()

  eq(vim.api.nvim_get_current_line(), "puts :hello")
  eq(notifications[1].message, "No RuboCop diagnostics found on the current line.")
  eq(notifications[1].level, vim.log.levels.WARN)
end

return T
