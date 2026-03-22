local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local expect = helpers.expect

local T = new_set({
  hooks = {
    pre_case = child.setup,
    post_once = child.stop,
  },
})

T["keymaps/clipboard.lua defines clipboard mappings and message copier"] = function()
  local result = child.lua_get([[
    (function()
      local copied = {}
      local notifications = {}
      local original_exec2 = vim.api.nvim_exec2
      local original_setreg = vim.fn.setreg
      local original_notify = vim.notify

      vim.api.nvim_exec2 = function(command, opts)
        if command == "1messages" and opts and opts.output then
          return { output = "line1\nline2" }
        end

        return original_exec2(command, opts)
      end

      vim.fn.setreg = function(register, value)
        copied[register] = value
      end

      vim.notify = function(message, level)
        table.insert(notifications, { message = message, level = level })
      end

      dofile("vim/plugin/config/keymaps/clipboard.lua")

      local copy_messages = vim.fn.maparg("<space>m", "n", false, true)
      copy_messages.callback()

      return {
        y_rhs = vim.fn.maparg("y", "x", false, true).rhs,
        p_rhs = vim.fn.maparg("p", "x", false, true).rhs,
        copy_path_rhs = vim.fn.maparg("<space>c", "n", false, true).rhs,
        copied_messages = copied["+"] or "",
        notify_message = notifications[1].message,
        notify_level = notifications[1].level,
      }
    end)()
  ]])

  eq(result.y_rhs, '"+y')
  eq(result.p_rhs, '"+p')
  eq(result.copy_path_rhs, ":CopyCurrentPath<cr>")
  eq(result.copied_messages, "line1\nline2")
  eq(result.notify_message, "last messages copied!")
  eq(result.notify_level, vim.log.levels.INFO)
end

T["keymaps/functions.lua dispatches search and editor commands"] = function()
  local result = child.lua_get([[
    (function()
      local search_calls = {}
      local execute_calls = {}
      local original_getenv = os.getenv
      local original_execute = os.execute

      package.loaded["search_word"] = {
        search_word = function(...)
          table.insert(search_calls, { ... })
        end,
      }

      os.getenv = function(name)
        if name == "CLOUD_NOTE_ROOT" then
          return "/tmp/cloud"
        end

        if name == "LOCAL_NOTE_ROOT" then
          return "/tmp/local"
        end

        return original_getenv(name)
      end

      os.execute = function(command)
        table.insert(execute_calls, command)
        return 0
      end

      vim.api.nvim_buf_set_name(0, "/tmp/current_note.md")
      dofile("vim/plugin/config/keymaps/functions.lua")

      vim.fn.maparg("<space>/", "n", false, true).callback()
      vim.fn.maparg("<space>on", "n", false, true).callback()
      vim.fn.maparg("<space>oc", "n", false, true).callback()
      vim.fn.maparg("<space>ov", "n", false, true).callback()

      return {
        slash_desc = vim.fn.maparg("<space>/", "n", false, true).silent,
        search_calls = search_calls,
        execute_calls = execute_calls,
      }
    end)()
  ]])

  eq(result.slash_desc, 0)
  eq(result.search_calls, {
    {},
    { "/tmp/local", "--sort path" },
    { "/tmp/cloud/cheat_sheets" },
  })
  eq(#result.execute_calls, 1)
  expect.match(result.execute_calls[1], "^code .*/current_note%.md$")
end

return T
