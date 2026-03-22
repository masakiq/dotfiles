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

T["search.lua configures search options and autocmd registrations"] = function()
  local config = child.lua_get([[
    (function()
      dofile("vim/plugin/config/search.lua")

      return {
        smartcase = vim.o.smartcase,
        incsearch = vim.o.incsearch,
        hlsearch = vim.o.hlsearch,
        quickfix_grep_autocmd = vim.fn.exists("#QuickFixCmdPost#*grep*"),
        qf_filetype_autocmd = vim.fn.exists("#FileType#qf"),
      }
    end)()
  ]])

  eq(config.smartcase, true)
  eq(config.incsearch, true)
  eq(config.hlsearch, false)
  eq(config.quickfix_grep_autocmd, 1)
  eq(config.qf_filetype_autocmd, 1)
end

T["search.lua resizes quickfix windows on qf FileType"] = function()
  local height = child.lua_get([[
    (function()
      dofile("vim/plugin/config/search.lua")

      vim.fn.setqflist({ { text = "item" } })
      vim.cmd("copen")
      vim.api.nvim_exec_autocmds("FileType", { pattern = "qf" })

      return vim.api.nvim_win_get_height(0)
    end)()
  ]])

  eq(height, 15)
end

return T
