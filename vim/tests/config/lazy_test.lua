local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

T["setup() bootstraps lazy and plug-compatible commands"] = function()
  helpers.track_editor_state({
    globals = { "dotfiles_lazy_setup_complete" },
    modules = { "config.lazy", "lazy" },
  })

  local lazy_setup_calls = 0
  local lazy_invocations = {}
  local lazy_plugins
  local lazy_opts
  local original_fs_stat

  vim.g.dotfiles_lazy_setup_complete = nil
  package.loaded["config.lazy"] = nil
  package.loaded["lazy"] = nil

  original_fs_stat = helpers.stub(vim.uv, "fs_stat", function(path)
    if path:match("lazy%.nvim$") then
      return { type = "directory" }
    end

    return original_fs_stat(path)
  end)

  helpers.with_module_stubs({
    lazy = {
      setup = function(plugins, opts)
        lazy_setup_calls = lazy_setup_calls + 1
        lazy_plugins = plugins
        lazy_opts = opts

        if vim.fn.exists(":Lazy") ~= 2 then
          vim.api.nvim_create_user_command("Lazy", function(command_opts)
            table.insert(lazy_invocations, command_opts.args)
          end, { nargs = "*" })
        end
      end,
    },
  }, function()
    require("config.lazy").setup()
  end)

  eq(lazy_setup_calls, 1)
  eq(vim.g.dotfiles_lazy_setup_complete, true)
  eq(vim.fn.exists(":PlugInstall"), 2)
  eq(vim.fn.exists(":PlugStatus"), 2)

  vim.cmd("PlugInstall")
  vim.cmd("PlugStatus")

  eq(lazy_invocations, { "install", "" })
  eq(lazy_opts.defaults.lazy, false)
  eq(lazy_opts.install.missing, true)
  helpers.expect.match(lazy_opts.lockfile, "lazy%-lock%.json$")
  eq(#lazy_plugins > 0, true)
end

T["setup() is idempotent"] = function()
  helpers.track_editor_state({
    globals = { "dotfiles_lazy_setup_complete" },
    modules = { "config.lazy", "lazy" },
  })

  local lazy_setup_calls = 0
  local original_fs_stat

  vim.g.dotfiles_lazy_setup_complete = nil
  package.loaded["config.lazy"] = nil
  package.loaded["lazy"] = nil

  original_fs_stat = helpers.stub(vim.uv, "fs_stat", function(path)
    if path:match("lazy%.nvim$") then
      return { type = "directory" }
    end

    return original_fs_stat(path)
  end)

  helpers.with_module_stubs({
    lazy = {
      setup = function()
        lazy_setup_calls = lazy_setup_calls + 1
      end,
    },
  }, function()
    local config = require("config.lazy")
    config.setup()
    config.setup()
  end)

  eq(lazy_setup_calls, 1)
end

return T
