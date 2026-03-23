local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["telescope.lua configures defaults, ui-select, and highlights"] = function()
  helpers.track_editor_state({
    modules = {
      "pickers.core",
      "telescope",
      "telescope.actions",
      "telescope.themes",
    },
  })

  local setup_config
  local loaded_extension
  local highlights_applied = 0

  helpers.with_module_stubs({
    ["pickers.core"] = {
      default_config = function()
        return { layout_strategy = "horizontal" }
      end,
      apply_highlights = function()
        highlights_applied = highlights_applied + 1
      end,
    },
    ["telescope"] = {
      setup = function(config)
        setup_config = config
      end,
      load_extension = function(name)
        loaded_extension = name
      end,
    },
    ["telescope.actions"] = {
      select_default = "select-default",
    },
    ["telescope.themes"] = {
      get_cursor = function(config)
        return vim.tbl_extend("force", { theme = "cursor" }, config)
      end,
    },
  }, function()
    dofile("vim/plugin/telescope.lua")
  end)

  eq(setup_config.defaults.layout_strategy, "horizontal")
  eq(setup_config.pickers.lsp_definitions.jump_type, "never")
  eq(setup_config.extensions["ui-select"].layout_config.width, 100)
  eq(setup_config.extensions["ui-select"].mappings.i["<CR>"], "select-default")
  eq(loaded_extension, "ui-select")
  eq(highlights_applied, 1)
end

return T
