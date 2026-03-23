local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["search.lua configures search options and autocmd registrations"] = function()
  helpers.track_editor_state({
    options = { "smartcase", "incsearch", "hlsearch" },
  })

  dofile("vim/plugin/config/search.lua")

  eq(vim.o.smartcase, true)
  eq(vim.o.incsearch, true)
  eq(vim.o.hlsearch, false)
  eq(vim.fn.exists("#QuickFixCmdPost#*grep*"), 1)
  eq(vim.fn.exists("#FileType#qf"), 1)
end

T["search.lua resizes quickfix windows on qf FileType"] = function()
  helpers.track_editor_state({
    options = { "smartcase", "incsearch", "hlsearch" },
  })

  dofile("vim/plugin/config/search.lua")

  vim.fn.setqflist({ { text = "item" } })
  vim.cmd("copen")
  vim.api.nvim_exec_autocmds("FileType", { pattern = "qf" })

  eq(vim.api.nvim_win_get_height(0), 15)
end

return T
