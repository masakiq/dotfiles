local M = {}

local function bootstrap_lazy()
  local uv = vim.uv or vim.loop
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not uv.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup(require("plugins"), {
    defaults = {
      lazy = false,
    },
    change_detection = {
      notify = false,
    },
    install = {
      missing = true,
    },
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  })
end

local function create_plug_compat_command(name, target)
  if vim.fn.exists(":" .. name) == 2 then
    return
  end

  vim.api.nvim_create_user_command(name, function()
    if target == "" then
      vim.cmd("Lazy")
      return
    end

    vim.cmd("Lazy " .. target)
  end, {})
end

function M.setup()
  bootstrap_lazy()

  create_plug_compat_command("PlugInstall", "install")
  create_plug_compat_command("PlugUpdate", "update")
  create_plug_compat_command("PlugClean", "clean")
  create_plug_compat_command("PlugStatus", "")
end

return M
