local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["copilot.lua returns quietly when the plugin module is unavailable"] = function()
  helpers.track_editor_state()

  local original_require = require
  helpers.stub(_G, "require", function(name)
    if name == "copilot" then
      error("module 'copilot' not found")
    end

    return original_require(name)
  end)

  local ok, err = pcall(dofile, "vim/plugin/copilot.lua")

  eq(ok, true)
  eq(err, nil)
end

T["copilot.lua passes the expected setup options"] = function()
  helpers.track_editor_state({
    modules = { "copilot" },
  })

  local seen_config

  helpers.with_module_stubs({
    copilot = {
      setup = function(config)
        seen_config = config
      end,
    },
  }, function()
    dofile("vim/plugin/copilot.lua")
  end)

  eq(seen_config.panel.enabled, true)
  eq(seen_config.panel.layout.position, "right")
  eq(seen_config.panel.keymap.open, "<M-Tab>")
  eq(seen_config.suggestion.auto_trigger, true)
  eq(seen_config.suggestion.keymap.accept, "<Tab>")
  eq(seen_config.filetypes.hgcommit, false)
  eq(seen_config.filetypes[".env"], false)
  eq(seen_config.copilot_node_command, "node")
end

return T
