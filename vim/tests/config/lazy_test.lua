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

T["setup() bootstraps lazy and plug-compatible commands"] = function()
  child.lua([[
    package.loaded["config.lazy"] = nil
    _G.lazy_setup_calls = 0
    _G.lazy_invocations = {}

    package.loaded["lazy"] = {
      setup = function(plugins, opts)
        _G.lazy_setup_calls = _G.lazy_setup_calls + 1
        _G.lazy_plugins = plugins
        _G.lazy_opts = opts

        if vim.fn.exists(":Lazy") ~= 2 then
          vim.api.nvim_create_user_command("Lazy", function(command_opts)
            table.insert(_G.lazy_invocations, command_opts.args)
          end, { nargs = "*" })
        end
      end,
    }

    local original_fs_stat = vim.uv.fs_stat
    vim.uv.fs_stat = function(path)
      if path:match("lazy%.nvim$") then
        return { type = "directory" }
      end

      return original_fs_stat(path)
    end

    require("config.lazy").setup()
  ]])

  eq(child.lua_get("_G.lazy_setup_calls"), 1)
  eq(child.g.dotfiles_lazy_setup_complete, true)
  eq(child.fn.exists(":PlugInstall"), 2)
  eq(child.fn.exists(":PlugStatus"), 2)

  child.cmd("PlugInstall")
  child.cmd("PlugStatus")

  eq(child.lua_get("_G.lazy_invocations"), { "install", "" })
  eq(child.lua_get("_G.lazy_opts.defaults.lazy"), false)
  eq(child.lua_get("_G.lazy_opts.install.missing"), true)
  helpers.expect.match(child.lua_get("_G.lazy_opts.lockfile"), "lazy%-lock%.json$")
  eq(child.lua_get("#_G.lazy_plugins > 0"), true)
end

T["setup() is idempotent"] = function()
  child.lua([[
    package.loaded["config.lazy"] = nil
    _G.lazy_setup_calls = 0

    package.loaded["lazy"] = {
      setup = function()
        _G.lazy_setup_calls = _G.lazy_setup_calls + 1
      end,
    }

    local original_fs_stat = vim.uv.fs_stat
    vim.uv.fs_stat = function(path)
      if path:match("lazy%.nvim$") then
        return { type = "directory" }
      end

      return original_fs_stat(path)
    end

    local config = require("config.lazy")
    config.setup()
    config.setup()
  ]])

  eq(child.lua_get("_G.lazy_setup_calls"), 1)
end

return T
