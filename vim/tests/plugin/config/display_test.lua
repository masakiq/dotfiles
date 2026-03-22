local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set
local expect = helpers.expect

local T = new_set({
  hooks = {
    pre_case = child.setup,
    post_once = child.stop,
  },
})

T["display.lua configures options, highlights, and colorscheme"] = function()
  local config = child.lua_get([[
    (function()
      vim.opt.runtimepath:append(vim.fn.getcwd() .. "/vim/tests/support")
      dofile("vim/plugin/config/display.lua")

      return {
        title = vim.o.title,
        number = vim.o.number,
        ruler = vim.o.ruler,
        wrap = vim.o.wrap,
        list = vim.o.list,
        laststatus = vim.o.laststatus,
        cmdheight = vim.o.cmdheight,
        showcmd = vim.o.showcmd,
        showmode = vim.o.showmode,
        cursorline = vim.o.cursorline,
        autoread = vim.o.autoread,
        colors_name = vim.g.colors_name,
        fillchar_vert = vim.opt.fillchars:get().vert,
        normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg,
        spellbad_undercurl = vim.api.nvim_get_hl(0, { name = "SpellBad" }).undercurl,
        txt_autocmd = vim.fn.exists("#BufRead#*.txt"),
        fish_autocmd = vim.fn.exists("#BufRead#*.fish"),
        log_autocmd = vim.fn.exists("#vimrcsyntax"),
      }
    end)()
  ]])

  eq(config.title, true)
  eq(config.number, true)
  eq(config.ruler, true)
  eq(config.wrap, true)
  eq(config.list, false)
  eq(config.laststatus, 3)
  eq(config.cmdheight, 1)
  eq(config.showcmd, true)
  eq(config.showmode, true)
  eq(config.cursorline, true)
  eq(config.autoread, true)
  eq(config.colors_name, "tokyonight")
  eq(config.fillchar_vert, " ")
  eq(config.normal_bg, 0)
  eq(config.spellbad_undercurl, true)
  eq(config.txt_autocmd, 1)
  eq(config.fish_autocmd, 1)
  eq(config.log_autocmd, 1)
end

T["display.lua applies syntax overrides for txt and fish files"] = function()
  local txt_path = vim.fn.tempname() .. ".txt"
  local fish_path = vim.fn.tempname() .. ".fish"

  child.lua("_G.phase2_txt_path = ...", { txt_path })
  child.lua("_G.phase2_fish_path = ...", { fish_path })

  local syntax = child.lua_get([[
    (function()
      vim.opt.runtimepath:append(vim.fn.getcwd() .. "/vim/tests/support")
      dofile("vim/plugin/config/display.lua")

      vim.cmd("edit " .. vim.fn.fnameescape(_G.phase2_txt_path))
      local txt_syntax = vim.bo.syntax

      vim.cmd("edit " .. vim.fn.fnameescape(_G.phase2_fish_path))
      local fish_syntax = vim.bo.syntax

      return {
        txt = txt_syntax,
        fish = fish_syntax,
      }
    end)()
  ]])

  eq(syntax.txt, "conf")
  eq(syntax.fish, "sh")
  eq(child.lua_get("vim.api.nvim_get_hl(0, { name = 'CursorLineNr' }).bg"), 0x222222)
end

return T
