local helpers = dofile("vim/tests/helpers.lua")

local child = helpers.new_child_neovim()
local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_once = child.setup,
    pre_case = child.reset,
    post_once = child.stop,
  },
})

T["visual_multi.lua applies the custom mono highlight and re-applies on ColorScheme"] = function()
  local config = child.lua_get([[
    (function()
      dofile("vim/plugin/visual_multi.lua")

      local initial = vim.api.nvim_get_hl(0, { name = "VisualMultiMono", link = false })
      vim.api.nvim_set_hl(0, "VisualMultiMono", { fg = "#000000", bg = "#000000" })
      vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
      local refreshed = vim.api.nvim_get_hl(0, { name = "VisualMultiMono", link = false })

      return {
        initial_bg = initial.bg,
        initial_fg = initial.fg,
        refreshed_bg = refreshed.bg,
        refreshed_fg = refreshed.fg,
        colorscheme_autocmds = #vim.api.nvim_get_autocmds({
          group = "dotfiles_visual_multi",
          event = "ColorScheme",
        }),
      }
    end)()
  ]])

  eq(config.initial_bg, 0xe0af68)
  eq(config.initial_fg, 0x1f2335)
  eq(config.refreshed_bg, 0xe0af68)
  eq(config.refreshed_fg, 0x1f2335)
  eq(config.colorscheme_autocmds, 1)
end

return T
