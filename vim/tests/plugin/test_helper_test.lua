local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local match = helpers.expect.match
local new_set = MiniTest.new_set

local T = new_set()

T["test_helper.lua sends ruby line tests and dart file tests to the tmux test pane"] = function()
  helpers.track_editor_state()

  local current = {
    path = "spec/models/user_spec.rb",
    ext = "rb",
    line = 37,
  }
  local jobstart_calls = {}
  local waits = {}

  helpers.stub(vim.fn, "system", function(command)
    if command:match("^tmux list%-panes %-a") then
      return "dev:1.2:test\n"
    end

    error("unexpected vim.fn.system call: " .. command)
  end)
  helpers.stub(vim.fn, "jobstart", function(command, opts)
    table.insert(jobstart_calls, {
      command = command,
      opts = opts,
    })
    return 1
  end)
  helpers.stub(vim.fn, "expand", function(expr)
    if expr == "%" then
      return current.path
    end

    if expr == "%:e" then
      return current.ext
    end

    return expr
  end)
  helpers.stub(vim.fn, "line", function(expr)
    if expr == "." then
      return current.line
    end

    return 0
  end)
  helpers.stub(vim, "wait", function(ms)
    table.insert(waits, ms)
    return true
  end)

  dofile("vim/plugin/test_helper.lua")

  vim.fn.maparg("T", "n", false, true).callback()

  current.path = "test/widget_test.dart"
  current.ext = "dart"
  vim.fn.maparg("<C-t>", "n", false, true).callback()

  eq(vim.fn.maparg("T", "n", false, true).desc, "Execute Test line")
  eq(vim.fn.maparg("<C-t>", "n", false, true).desc, "Execute Test (file)")
  match(jobstart_calls[1].command, "rspec spec/models/user_spec.rb:37")
  match(jobstart_calls[1].command, "tmux send %-t dev:1.2")
  match(jobstart_calls[2].command, "flutter test test/widget_test.dart")
  match(jobstart_calls[2].command, "tmux send %-t dev:1.2")
  eq(jobstart_calls[1].opts.detach, true)
  eq(jobstart_calls[2].opts.detach, true)
  eq(waits, { 100 })
end

return T
