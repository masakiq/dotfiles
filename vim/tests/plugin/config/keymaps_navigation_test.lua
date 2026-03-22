local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_case = child.setup,
    post_once = child.stop,
  },
})

T["move.lua, terminal.lua, and window.lua define navigation mappings"] = function()
  local result = child.lua_get([[
    (function()
      dofile("vim/plugin/config/keymaps/move.lua")
      dofile("vim/plugin/config/keymaps/terminal.lua")
      dofile("vim/plugin/config/keymaps/window.lua")

      return {
        move_j_rhs = vim.fn.maparg("j", "n", false, true).rhs,
        insert_right_rhs = vim.fn.maparg("<M-right>", "i", false, true).rhs,
        terminal_rhs = vim.fn.maparg("jf", "t", false, true).rhs,
        width_rhs = vim.fn.maparg("<space><left>", "n", false, true).rhs,
      }
    end)()
  ]])

  eq(result.move_j_rhs, "gj")
  eq(result.insert_right_rhs, "<right><right><right><right><right>")
  eq(result.terminal_rhs, "<C-\\><C-n>")
  eq(result.width_rhs, "20<C-w>>")
end

T["keymaps/quickfix.lua defines commands and toggles quickfix windows"] = function()
  local result = child.lua_get([[
    (function()
      dofile("vim/plugin/config/keymaps/quickfix.lua")

      local function quickfix_window_count()
        local count = 0

        for _, win in pairs(vim.fn.getwininfo()) do
          if win.quickfix == 1 then
            count = count + 1
          end
        end

        return count
      end

      vim.fn.setqflist({ { text = "item" } })

      local toggle = vim.fn.maparg("<space>a", "n", false, true)
      toggle.callback()
      local after_open = quickfix_window_count()
      toggle.callback()
      local after_close = quickfix_window_count()

      return {
        next_exists = vim.fn.exists(":NextQuickfix"),
        previous_exists = vim.fn.exists(":PreviousQuickfix"),
        toggle_exists = vim.fn.exists(":ToggleQuickfix"),
        after_open = after_open,
        after_close = after_close,
      }
    end)()
  ]])

  eq(result.next_exists, 2)
  eq(result.previous_exists, 2)
  eq(result.toggle_exists, 2)
  eq(result.after_open, 1)
  eq(result.after_close, 0)
end

T["keymaps/tab.lua defines non-gui tab navigation maps"] = function()
  local result = child.lua_get([[
    (function()
      local original_has = vim.fn.has

      vim.fn.has = function(name)
        if name == "gui_running" then
          return 0
        end

        return original_has(name)
      end

      dofile("vim/plugin/config/keymaps/tab.lua")

      return {
        new_desc = vim.fn.maparg("<space>t", "n", false, true).desc,
        prev_desc = vim.fn.maparg("<space>;", "n", false, true).desc,
        next_desc = vim.fn.maparg("<space>'", "n", false, true).desc,
        right_desc = vim.fn.maparg("<space>.", "n", false, true).desc,
        left_desc = vim.fn.maparg("<space>,", "n", false, true).desc,
      }
    end)()
  ]])

  eq(result.new_desc, "新規タブを開く")
  eq(result.prev_desc, "前のタブに移動")
  eq(result.next_desc, "次のタブに移動")
  eq(result.right_desc, "現タブを右に移動")
  eq(result.left_desc, "現タブを左に移動")
end

return T
