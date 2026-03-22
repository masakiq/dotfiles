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

T["keymaps/basic.lua defines maps, toggle callbacks, and macism autocmd"] = function()
  local result = child.lua_get([[
    (function()
      local executed = {}
      local original_executable = vim.fn.executable
      local original_execute = os.execute

      vim.fn.executable = function(name)
        if name == "macism" then
          return 1
        end

        return original_executable(name)
      end

      os.execute = function(command)
        table.insert(executed, command)
        return 0
      end

      dofile("vim/plugin/config/keymaps/basic.lua")

      local jk = vim.fn.maparg("jk", "i", false, true)
      local kana = vim.fn.maparg("あ", "n", false, true)
      local save = vim.fn.maparg("<space>w", "n", false, true)
      local toggle_search = vim.fn.maparg("<space>i", "n", false, true)
      local toggle_number = vim.fn.maparg("<space>n", "n", false, true)

      local hl_before = vim.o.hlsearch
      local number_before = vim.o.number

      toggle_search.callback()
      toggle_number.callback()
      vim.api.nvim_exec_autocmds("InsertLeave", {})

      return {
        jk_rhs = jk.rhs,
        kana_rhs = kana.rhs,
        save_rhs = save.rhs,
        hl_before = hl_before,
        hl_after = vim.o.hlsearch,
        number_before = number_before,
        number_after = vim.o.number,
        macism_commands = executed,
        has_insertleave = vim.fn.exists("#InsertLeave#*"),
      }
    end)()
  ]])

  eq(result.jk_rhs, "<esc>")
  eq(result.kana_rhs, "a")
  eq(result.save_rhs, ":w!<CR>")
  eq(result.hl_after, not result.hl_before)
  eq(result.number_after, not result.number_before)
  eq(result.macism_commands, { "macism com.apple.keylayout.ABC" })
  eq(result.has_insertleave, 1)
end

T["keymaps/completion.lua overrides insert completion behavior"] = function()
  local result = child.lua_get([[
    (function()
      dofile("vim/plugin/config/keymaps/completion.lua")

      local ctrl_n = vim.fn.maparg("<C-n>", "i", false, true)
      local ctrl_p = vim.fn.maparg("<C-p>", "i", false, true)

      return {
        completeopt = vim.opt.completeopt:get(),
        ctrl_n_expr = ctrl_n.expr,
        ctrl_p_expr = ctrl_p.expr,
        ctrl_n_callback = type(ctrl_n.callback),
        ctrl_p_callback = type(ctrl_p.callback),
      }
    end)()
  ]])

  eq(result.completeopt, { "menuone", "noinsert" })
  eq(result.ctrl_n_expr, 1)
  eq(result.ctrl_p_expr, 1)
  eq(result.ctrl_n_callback, "function")
  eq(result.ctrl_p_callback, "function")
end

T["keymaps/surround.lua defines visual surround mappings"] = function()
  local result = child.lua_get([[
    (function()
      dofile("vim/plugin/config/keymaps/surround.lua")

      local single = vim.fn.maparg("'", "x", false, true)
      local angle = vim.fn.maparg("<", "x", false, true)
      local backspace = vim.fn.maparg("<bs>", "x", false, true)

      return {
        single_rhs = single.rhs,
        angle_rhs = angle.rhs,
        backspace_rhs = backspace.rhs,
      }
    end)()
  ]])

  eq(result.single_rhs, "c'<C-r>\"'<Esc>")
  eq(result.angle_rhs, 'c<<C-r>"><Esc>')
  eq(result.backspace_rhs, 'c<Right><Bs><Bs><C-r>"<Esc>')
end

return T
