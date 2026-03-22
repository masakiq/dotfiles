vim.cmd("set exrc&vim secure")
vim.o.loadplugins = false
vim.opt.shada = ""

local cwd = vim.fn.getcwd()

vim.opt.runtimepath:append(cwd .. "/vim")
vim.opt.runtimepath:append(cwd .. "/vim/deps/mini.nvim")

package.path = table.concat({
  cwd .. "/vim/tests/?.lua",
  cwd .. "/vim/tests/?/init.lua",
  cwd .. "/vim/scripts/?.lua",
  cwd .. "/vim/scripts/?/init.lua",
  package.path,
}, ";")

require("mini.test").setup({
  script_path = "vim/scripts/minitest.lua",
})
