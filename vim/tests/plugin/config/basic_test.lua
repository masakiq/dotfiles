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

T["basic.lua, file_operation.lua, and scroll.lua configure options and autocmds"] = function()
  local config = child.lua_get([[
    (function()
      dofile("vim/plugin/config/basic.lua")
      dofile("vim/plugin/config/file_operation.lua")
      dofile("vim/plugin/config/scroll.lua")

      vim.wo.foldmethod = "manual"
      vim.api.nvim_exec_autocmds("FileType", { pattern = "vim" })

      return {
        compatible = vim.o.compatible,
        encoding = vim.o.encoding,
        fileformats = vim.o.fileformats,
        splitbelow = vim.o.splitbelow,
        splitright = vim.o.splitright,
        backup = vim.o.backup,
        swapfile = vim.o.swapfile,
        scrolloff = vim.o.scrolloff,
        mouse = vim.o.mouse,
        foldmethod = vim.wo.foldmethod,
        has_filetype_group = vim.fn.exists("#filetype_vim"),
        has_resize_group = vim.fn.exists("#ResizeEqualWindows"),
      }
    end)()
  ]])

  eq(config.compatible, false)
  eq(config.encoding, "utf-8")
  eq(config.fileformats, "unix,dos,mac")
  eq(config.splitbelow, true)
  eq(config.splitright, true)
  eq(config.backup, false)
  eq(config.swapfile, false)
  eq(config.scrolloff, 15)
  eq(config.mouse, "a")
  eq(config.foldmethod, "marker")
  eq(config.has_filetype_group, 1)
  eq(config.has_resize_group, 1)
end

return T
