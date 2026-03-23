local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local match = helpers.expect.match
local new_set = MiniTest.new_set

local T = new_set()

T["which_key.lua registers labels, mappings, and highlight autocmds"] = function()
  helpers.track_editor_state({
    globals = {
      "dotfiles_which_key_registered",
      "which_key_map",
      "which_key_use_floating_win",
    },
  })

  local registrations = {}

  helpers.stub(vim.fn, "has", function(feature)
    if feature == "gui_running" then
      return 0
    end

    return 0
  end)
  helpers.stub(vim.fn, "which_key#register", function(prefix, map)
    table.insert(registrations, { prefix, map })
    return 1
  end)

  dofile("vim/plugin/which_key.lua")

  eq(vim.g.which_key_map["/"], "Search Word or Open File")
  eq(vim.g.which_key_use_floating_win, 1)
  eq(vim.g.dotfiles_which_key_registered, true)
  match(vim.fn.maparg("<space>", "n"), "WhichKey")
  match(vim.fn.maparg("<leader>", "n"), "WhichKey")
  match(vim.fn.maparg("<space>", "x"), "WhichKeyVisual")
  eq(#vim.api.nvim_get_autocmds({ group = "WhichKeyColors" }), 1)
  eq(registrations, {
    { "<space>", "g:which_key_map" },
    { "<leader>", "g:which_key_map" },
  })
end

return T
