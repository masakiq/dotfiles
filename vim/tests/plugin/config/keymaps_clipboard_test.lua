local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local expect = helpers.expect

local T = new_set()

T["keymaps/clipboard.lua defines clipboard mappings and message copier"] = function()
  helpers.track_editor_state()

  local copied = {}
  local notifications = {}
  local original_exec2

  original_exec2 = helpers.stub(vim.api, "nvim_exec2", function(command, opts)
    if command == "1messages" and opts and opts.output then
      return { output = "line1\nline2" }
    end

    return original_exec2(command, opts)
  end)

  helpers.stub(vim.fn, "setreg", function(register, value)
    copied[register] = value
  end)

  helpers.stub(vim, "notify", function(message, level)
    table.insert(notifications, { message = message, level = level })
  end)

  dofile("vim/plugin/config/keymaps/clipboard.lua")

  local copy_messages = vim.fn.maparg("<space>m", "n", false, true)
  copy_messages.callback()

  eq(vim.fn.maparg("y", "x", false, true).rhs, '"+y')
  eq(vim.fn.maparg("p", "x", false, true).rhs, '"+p')
  eq(vim.fn.maparg("<space>c", "n", false, true).rhs, ":CopyCurrentPath<cr>")
  eq(copied["+"], "line1\nline2")
  eq(notifications[1].message, "last messages copied!")
  eq(notifications[1].level, vim.log.levels.INFO)
end

T["keymaps/functions.lua dispatches search and editor commands"] = function()
  helpers.track_editor_state({
    modules = { "search_word" },
  })

  local search_calls = {}
  local execute_calls = {}
  local original_getenv

  original_getenv = helpers.stub(os, "getenv", function(name)
    if name == "CLOUD_NOTE_ROOT" then
      return "/tmp/cloud"
    end

    if name == "LOCAL_NOTE_ROOT" then
      return "/tmp/local"
    end

    return original_getenv(name)
  end)

  helpers.stub(os, "execute", function(command)
    table.insert(execute_calls, command)
    return 0
  end)

  helpers.make_scratch_buffer({ "note" }, "/tmp/current_note.md")

  helpers.with_module_stubs({
    search_word = {
      search_word = function(...)
        table.insert(search_calls, { ... })
      end,
    },
  }, function()
    dofile("vim/plugin/config/keymaps/functions.lua")
  end)

  vim.fn.maparg("<space>/", "n", false, true).callback()
  vim.fn.maparg("<space>on", "n", false, true).callback()
  vim.fn.maparg("<space>oc", "n", false, true).callback()
  vim.fn.maparg("<space>ov", "n", false, true).callback()

  eq(vim.fn.maparg("<space>/", "n", false, true).silent, 0)
  eq(search_calls, {
    {},
    { "/tmp/local", "--sort path" },
    { "/tmp/cloud/cheat_sheets" },
  })
  eq(#execute_calls, 1)
  expect.match(execute_calls[1], "^code .*/current_note%.md$")
end

return T
