local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["basic.lua, file_operation.lua, and scroll.lua configure options and autocmds"] = function()
  helpers.track_editor_state({
    options = {
      "compatible",
      "encoding",
      "fileformats",
      "splitbelow",
      "splitright",
      "backup",
      "swapfile",
      "scrolloff",
      "mouse",
    },
    window_options = { "foldmethod" },
  })

  dofile("vim/plugin/config/basic.lua")
  dofile("vim/plugin/config/file_operation.lua")
  dofile("vim/plugin/config/scroll.lua")

  vim.wo.foldmethod = "manual"
  vim.api.nvim_exec_autocmds("FileType", { pattern = "vim" })

  eq(vim.o.compatible, false)
  eq(vim.o.encoding, "utf-8")
  eq(vim.o.fileformats, "unix,dos,mac")
  eq(vim.o.splitbelow, true)
  eq(vim.o.splitright, true)
  eq(vim.o.backup, false)
  eq(vim.o.swapfile, false)
  eq(vim.o.scrolloff, 15)
  eq(vim.o.mouse, "a")
  eq(vim.wo.foldmethod, "marker")
  eq(vim.fn.exists("#filetype_vim"), 1)
  eq(vim.fn.exists("#ResizeEqualWindows"), 1)
end

return T
