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

T["snippet.lua defines Ruby insert abbreviations"] = function()
  local output = child.lua_get([[
    (function()
      dofile("vim/plugin/config/snippet.lua")

      vim.bo.filetype = "ruby"
      vim.cmd("doautocmd <nomodeline> FileType ruby")

      return vim.api.nvim_exec2("iabbrev <buffer>", { output = true }).output
    end)()
  ]])

  expect.match(output, "fro")
  expect.match(output, "yar")
  expect.match(output, "des")
  expect.match(output, "beh")
end

T["snippet.lua marks markdown files and defines markdown abbreviations"] = function()
  local path = vim.fn.tempname() .. ".md"
  child.lua("_G.phase2_markdown_path = ...", { path })

  local result = child.lua_get([[
    (function()
      dofile("vim/plugin/config/snippet.lua")

      vim.cmd("edit " .. vim.fn.fnameescape(_G.phase2_markdown_path))
      vim.cmd("doautocmd <nomodeline> FileType markdown")

      return {
        filetype = vim.bo.filetype,
        abbreviations = vim.api.nvim_exec2("iabbrev <buffer>", { output = true }).output,
      }
    end)()
  ]])

  eq(result.filetype, "markdown")
  expect.match(result.abbreviations, "tab")
  expect.match(result.abbreviations, "<table>")
end

return T
