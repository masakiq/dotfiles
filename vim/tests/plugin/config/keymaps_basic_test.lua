local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["keymaps/basic.lua defines maps, toggle callbacks, and macism autocmd"] = function()
  helpers.track_editor_state({
    options = { "hlsearch", "number", "completeopt" },
  })

  local executed = {}
  local original_executable

  original_executable = helpers.stub(vim.fn, "executable", function(name)
    if name == "macism" then
      return 1
    end

    return original_executable(name)
  end)

  helpers.stub(os, "execute", function(command)
    table.insert(executed, command)
    return 0
  end)

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

  eq(jk.rhs, "<esc>")
  eq(kana.rhs, "a")
  eq(save.rhs, ":w!<CR>")
  eq(vim.o.hlsearch, not hl_before)
  eq(vim.o.number, not number_before)
  eq(executed, { "macism com.apple.keylayout.ABC" })
  eq(vim.fn.exists("#InsertLeave#*"), 1)
end

T["keymaps/completion.lua overrides insert completion behavior"] = function()
  helpers.track_editor_state({
    options = { "completeopt" },
  })

  dofile("vim/plugin/config/keymaps/completion.lua")

  local ctrl_n = vim.fn.maparg("<C-n>", "i", false, true)
  local ctrl_p = vim.fn.maparg("<C-p>", "i", false, true)

  eq(vim.opt.completeopt:get(), { "menuone", "noinsert" })
  eq(ctrl_n.expr, 1)
  eq(ctrl_p.expr, 1)
  eq(type(ctrl_n.callback), "function")
  eq(type(ctrl_p.callback), "function")
end

T["keymaps/surround.lua defines visual surround mappings"] = function()
  helpers.track_editor_state()

  dofile("vim/plugin/config/keymaps/surround.lua")

  local single = vim.fn.maparg("'", "x", false, true)
  local angle = vim.fn.maparg("<", "x", false, true)
  local backspace = vim.fn.maparg("<bs>", "x", false, true)

  eq(single.rhs, "c'<C-r>\"'<Esc>")
  eq(angle.rhs, 'c<<C-r>"><Esc>')
  eq(backspace.rhs, 'c<Right><Bs><Bs><C-r>"<Esc>')
end

return T
