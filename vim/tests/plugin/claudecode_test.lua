local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local match = helpers.expect.match
local new_set = MiniTest.new_set

local T = new_set()

T["claudecode.lua warns when the plugin module is unavailable"] = function()
  helpers.track_editor_state()

  local notifications = helpers.track_notify()
  local original_require = require

  helpers.stub(_G, "require", function(name)
    if name == "claudecode" then
      error("module 'claudecode' not found")
    end

    return original_require(name)
  end)

  dofile("vim/plugin/claudecode.lua")

  eq(notifications[#notifications].message, "claudecode.nvim plugin not found")
  eq(notifications[#notifications].level, vim.log.levels.WARN)
end

T["claudecode.lua configures the plugin, keymaps, command, and shutdown hook"] = function()
  helpers.track_editor_state({
    modules = { "claudecode" },
  })

  local notifications = helpers.track_notify()
  local setup_config
  local status_calls = 0
  local stop_calls = 0

  helpers.with_module_stubs({
    claudecode = {
      setup = function(config)
        setup_config = config
      end,
      status = function()
        status_calls = status_calls + 1
        return { running = true }
      end,
      stop = function()
        stop_calls = stop_calls + 1
      end,
    },
  }, function()
    dofile("vim/plugin/claudecode.lua")
  end)

  vim.cmd("ClaudeCodeStatus")
  local leave_pre = vim.api.nvim_get_autocmds({
    event = "VimLeavePre",
    group = "ClaudeCodeConfig",
  })[1]
  leave_pre.callback()

  eq(setup_config.auto_start, true)
  eq(setup_config.track_selection, true)
  eq(setup_config.port_range.min, 10000)
  eq(setup_config.terminal.provider, "native")
  eq(vim.fn.exists(":ClaudeCodeStatus"), 2)
  eq(vim.fn.maparg("<leader>ac", "n", false, true).desc, "Toggle Claude Terminal")
  eq(vim.fn.maparg("<leader>ak", "v", false, true).desc, "Send selection to Claude Code")
  eq(vim.fn.maparg("<leader>dq", "n", false, true).desc, "Exit diff mode")
  match(vim.fn.maparg("<space>oj", "n"), "ClaudeCode")
  eq(status_calls, 1)
  eq(stop_calls, 1)
  eq(notifications[1].message, "claudecode.nvim successfully configured")
  match(notifications[#notifications].message, "Claude Code Status:")
end

return T
