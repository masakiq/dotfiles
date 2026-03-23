vim.cmd("set exrc&vim secure")
vim.o.loadplugins = false
vim.opt.shada = ""

local cwd = vim.fn.getcwd()
local uv = vim.uv or vim.loop
local mini_repo = "https://github.com/nvim-mini/mini.nvim"
local mini_commit = vim.env.MINI_NVIM_COMMIT or "a995fe9cd4193fb492b5df69175a351a74b3d36b"

local function trim(text)
  return (text or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function run_system(cmd, context)
  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    error(("Failed to %s: %s"):format(context, trim(result)))
  end

  return result
end

local function sync_mini_repo(mini_path)
  if not uv.fs_stat(mini_path) then
    vim.fn.mkdir(vim.fn.fnamemodify(mini_path, ":h"), "p")
    vim.cmd([[echo "Installing pinned `mini.nvim` for tests" | redraw]])
    run_system({
      "git",
      "clone",
      "--filter=blob:none",
      "--no-checkout",
      mini_repo,
      mini_path,
    }, "clone mini.nvim for tests")
  end

  local current_commit = trim(vim.fn.system({
    "git",
    "-C",
    mini_path,
    "rev-parse",
    "HEAD",
  }))

  if vim.v.shell_error == 0 and current_commit == mini_commit then
    return false
  end

  run_system({
    "git",
    "-C",
    mini_path,
    "fetch",
    "--depth=1",
    "origin",
    mini_commit,
  }, "fetch pinned mini.nvim commit for tests")
  run_system({
    "git",
    "-C",
    mini_path,
    "checkout",
    "--detach",
    mini_commit,
  }, "checkout pinned mini.nvim commit for tests")

  return true
end

local function ensure_mini()
  local package_path = vim.fn.stdpath("data") .. "/site"
  local mini_path = package_path .. "/pack/deps/start/mini.nvim"
  local changed = sync_mini_repo(mini_path)

  if changed then
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd([[echo "Pinned `mini.nvim` for tests" | redraw]])
    return
  end

  vim.cmd("packadd mini.nvim")
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
