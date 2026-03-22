local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["move.lua, terminal.lua, and window.lua define navigation mappings"] = function()
  helpers.track_editor_state()

  dofile("vim/plugin/config/keymaps/move.lua")
  dofile("vim/plugin/config/keymaps/terminal.lua")
  dofile("vim/plugin/config/keymaps/window.lua")

  eq(vim.fn.maparg("j", "n", false, true).rhs, "gj")
  eq(vim.fn.maparg("<M-right>", "i", false, true).rhs, "<right><right><right><right><right>")
  eq(vim.fn.maparg("jf", "t", false, true).rhs, "<C-\\><C-n>")
  eq(vim.fn.maparg("<space><left>", "n", false, true).rhs, "20<C-w>>")
end

T["keymaps/quickfix.lua defines commands and toggles quickfix windows"] = function()
  helpers.track_editor_state()

  local function quickfix_window_count()
    local count = 0

    for _, win in pairs(vim.fn.getwininfo()) do
      if win.quickfix == 1 then
        count = count + 1
      end
    end

    return count
  end

  dofile("vim/plugin/config/keymaps/quickfix.lua")

  vim.fn.setqflist({ { text = "item" } })

  local toggle = vim.fn.maparg("<space>a", "n", false, true)
  toggle.callback()
  local after_open = quickfix_window_count()
  toggle.callback()
  local after_close = quickfix_window_count()

  eq(vim.fn.exists(":NextQuickfix"), 2)
  eq(vim.fn.exists(":PreviousQuickfix"), 2)
  eq(vim.fn.exists(":ToggleQuickfix"), 2)
  eq(after_open, 1)
  eq(after_close, 0)
end

T["keymaps/tab.lua defines non-gui tab navigation maps"] = function()
  helpers.track_editor_state()

  local original_has

  original_has = helpers.stub(vim.fn, "has", function(name)
    if name == "gui_running" then
      return 0
    end

    return original_has(name)
  end)

  dofile("vim/plugin/config/keymaps/tab.lua")

  eq(vim.fn.maparg("<space>t", "n", false, true).desc, "新規タブを開く")
  eq(vim.fn.maparg("<space>;", "n", false, true).desc, "前のタブに移動")
  eq(vim.fn.maparg("<space>'", "n", false, true).desc, "次のタブに移動")
  eq(vim.fn.maparg("<space>.", "n", false, true).desc, "現タブを右に移動")
  eq(vim.fn.maparg("<space>,", "n", false, true).desc, "現タブを左に移動")
end

return T
