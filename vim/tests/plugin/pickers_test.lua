local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["pickers.lua registers commands and keymaps that dispatch to picker commands"] = function()
  helpers.track_editor_state({
    modules = { "commands.pickers" },
  })

  local calls = {}

  helpers.with_module_stubs({
    ["commands.pickers"] = {
      files = function(arg)
        table.insert(calls, { "files", arg })
      end,
      buffers = function()
        table.insert(calls, { "buffers" })
      end,
      windows = function()
        table.insert(calls, { "windows" })
      end,
      open_all_files = function()
        table.insert(calls, { "open_all_files" })
      end,
      open_target_file = function()
        table.insert(calls, { "open_target_file" })
      end,
      copy_status_message = function()
        table.insert(calls, { "copy_status_message" })
      end,
      switch_project = function()
        table.insert(calls, { "switch_project" })
      end,
      open_files = function()
        table.insert(calls, { "open_files" })
      end,
      search_word_by_selected_text = function()
        table.insert(calls, { "search_word_by_selected_text" })
      end,
    },
  }, function()
    dofile("vim/plugin/pickers.lua")
  end)

  vim.cmd("Files app/models")
  vim.cmd("Buffers")
  vim.cmd("Windows")
  vim.cmd("OpenAllFiles")
  vim.cmd("OpenTargetFile")
  vim.cmd("CopyStatusMessage")
  vim.cmd("SwitchProject")
  vim.fn.maparg("<space>of", "n", false, true).callback()
  vim.fn.maparg("<space>ot", "n", false, true).callback()
  vim.fn.maparg("<space>/", "x", false, true).callback()

  eq(vim.fn.exists(":Files"), 2)
  eq(vim.fn.exists(":Buffers"), 2)
  eq(vim.fn.exists(":Windows"), 2)
  eq(calls, {
    { "files", "app/models" },
    { "buffers" },
    { "windows" },
    { "open_all_files" },
    { "open_target_file" },
    { "copy_status_message" },
    { "switch_project" },
    { "open_files" },
    { "open_target_file" },
    { "search_word_by_selected_text" },
  })
end

return T
