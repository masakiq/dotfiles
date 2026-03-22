local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local expect = helpers.expect

local T = new_set({
  hooks = {
    pre_once = child.setup,
    pre_case = child.reset,
    post_once = child.stop,
  },
})

local function load_editor(undo_dir)
  child.lua(
    [[
    local undo_dir = ...
    local original_expand = vim.fn.expand

    vim.fn.expand = function(path)
      if path == "~/.local/share/nvim/undo" then
        return undo_dir
      end

      return original_expand(path)
    end

    dofile("vim/plugin/config/editor.lua")
  ]],
    { undo_dir }
  )
end

T["editor.lua configures editing defaults and persistent undo"] = function()
  local undo_dir = vim.fn.tempname()

  load_editor(undo_dir)

  local config = child.lua_get([[
    {
      tabstop = vim.o.tabstop,
      softtabstop = vim.o.softtabstop,
      shiftwidth = vim.o.shiftwidth,
      expandtab = vim.o.expandtab,
      autoindent = vim.o.autoindent,
      backspace = vim.o.backspace,
      wrapscan = vim.o.wrapscan,
      showmatch = vim.o.showmatch,
      wildmenu = vim.o.wildmenu,
      wildmode = vim.o.wildmode,
      formatoptions = vim.opt.formatoptions:get(),
      spell = vim.o.spell,
      spelllang = vim.opt.spelllang:get(),
      hidden = vim.o.hidden,
      undodir = vim.o.undodir,
      undofile = vim.o.undofile,
    }
  ]])

  eq(config.tabstop, 2)
  eq(config.softtabstop, 2)
  eq(config.shiftwidth, 2)
  eq(config.expandtab, true)
  eq(config.autoindent, true)
  eq(config.backspace, "indent,eol,start")
  eq(config.wrapscan, true)
  eq(config.showmatch, true)
  eq(config.wildmenu, true)
  eq(config.wildmode, "longest:full,full")
  eq(config.formatoptions.m, true)
  eq(config.formatoptions.M, true)
  eq(config.spell, true)
  eq(config.spelllang, { "en", "cjk" })
  eq(config.hidden, true)
  eq(config.undodir, undo_dir)
  eq(config.undofile, true)
end

T["editor.lua trims trailing spaces on write and preserves cursor"] = function()
  local undo_dir = vim.fn.tempname()
  local path = vim.fn.tempname() .. ".lua"

  load_editor(undo_dir)
  child.lua("_G.phase2_editor_write_path = ...", { path })

  local result = child.lua_get([[
    (function()
      vim.cmd("edit " .. vim.fn.fnameescape(_G.phase2_editor_write_path))
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "aaa   ", "bbb  " })
      vim.bo.filetype = "lua"
      vim.api.nvim_win_set_cursor(0, { 1, 2 })
      vim.cmd("write!")

      return {
        lines = vim.api.nvim_buf_get_lines(0, 0, -1, false),
        cursor = vim.api.nvim_win_get_cursor(0),
      }
    end)()
  ]])

  eq(result.lines, { "aaa", "bbb" })
  eq(result.cursor, { 1, 2 })
end

T["editor.lua skips trailing-space trimming for markdown"] = function()
  local undo_dir = vim.fn.tempname()
  local path = vim.fn.tempname() .. ".md"

  load_editor(undo_dir)
  child.lua("_G.phase2_editor_markdown_path = ...", { path })

  local lines = child.lua_get([[
    (function()
      vim.cmd("edit " .. vim.fn.fnameescape(_G.phase2_editor_markdown_path))
      vim.api.nvim_buf_set_lines(0, 0, -1, false, { "aaa   " })
      vim.bo.filetype = "markdown"
      vim.cmd("write!")

      return vim.api.nvim_buf_get_lines(0, 0, -1, false)
    end)()
  ]])

  eq(lines, { "aaa   " })
end

return T
