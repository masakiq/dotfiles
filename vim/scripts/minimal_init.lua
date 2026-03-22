vim.cmd("set exrc&vim secure")
vim.o.loadplugins = false
vim.opt.shada = ""

local cwd = vim.fn.getcwd()
local uv = vim.uv or vim.loop

local function ensure_mini()
  local package_path = vim.fn.stdpath("data") .. "/site"
  local mini_path = package_path .. "/pack/deps/start/mini.nvim"

  if uv.fs_stat(mini_path) then
    vim.cmd("packadd mini.nvim")
    return
  end

  vim.fn.mkdir(package_path .. "/pack/deps/start", "p")
  vim.cmd([[echo "Installing `mini.nvim` for tests" | redraw]])

  local clone_result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/nvim-mini/mini.nvim",
    mini_path,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to install mini.nvim for tests: " .. clone_result)
  end

  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd([[echo "Installed `mini.nvim` for tests" | redraw]])
end

vim.opt.runtimepath:append(cwd .. "/vim")

package.path = table.concat({
  cwd .. "/vim/tests/?.lua",
  cwd .. "/vim/tests/?/init.lua",
  cwd .. "/vim/scripts/?.lua",
  cwd .. "/vim/scripts/?/init.lua",
  package.path,
}, ";")

ensure_mini()

require("mini.test").setup({
  script_path = "vim/scripts/minitest.lua",
})
