local helpers = dofile("vim/tests/helpers.lua")

local eq = MiniTest.expect.equality
local new_set = MiniTest.new_set

local T = new_set()

local function with_copilot_auth_env(config_home, callback)
  local original_config_home = vim.env.XDG_CONFIG_HOME
  vim.env.XDG_CONFIG_HOME = config_home

  MiniTest.finally(function()
    vim.env.XDG_CONFIG_HOME = original_config_home
  end)

  return callback()
end

T["copilot.lua returns quietly when the plugin module is unavailable"] = function()
  helpers.track_editor_state()

  local original_require = require
  helpers.stub(_G, "require", function(name)
    if name == "copilot" then
      error("module 'copilot' not found")
    end

    return original_require(name)
  end)

  local ok, err = pcall(dofile, "vim/plugin/copilot.lua")

  eq(ok, true)
  eq(err, nil)
end

T["copilot.lua passes the expected setup options"] = function()
  helpers.track_editor_state({
    modules = { "copilot" },
  })

  local seen_config

  helpers.with_module_stubs({
    copilot = {
      setup = function(config)
        seen_config = config
      end,
    },
  }, function()
    helpers.stub(vim.fn, "filereadable", function()
      return 0
    end)
    dofile("vim/plugin/copilot.lua")
  end)

  eq(seen_config.panel.enabled, true)
  eq(seen_config.panel.layout.position, "right")
  eq(seen_config.panel.keymap.open, "<M-Tab>")
  eq(seen_config.suggestion.auto_trigger, true)
  eq(seen_config.suggestion.keymap.accept, "<Tab>")
  eq(seen_config.filetypes.hgcommit, false)
  eq(seen_config.filetypes[".env"], false)
  eq(seen_config.copilot_node_command, "node")
end

T["copilot.lua defers setup until VimEnter during startup"] = function()
  helpers.track_editor_state({
    modules = { "copilot" },
  })

  local setup_called = false
  local created_autocmd

  helpers.stub(vim.api, "nvim_get_vvar", function(name)
    eq(name, "vim_did_enter")
    return 0
  end)
  helpers.stub(vim.api, "nvim_create_autocmd", function(event, opts)
    created_autocmd = {
      event = event,
      opts = opts,
    }
    return 11
  end)

  helpers.with_module_stubs({
    copilot = {
      setup = function()
        setup_called = true
      end,
    },
  }, function()
    helpers.stub(vim.fn, "filereadable", function()
      return 0
    end)
    dofile("vim/plugin/copilot.lua")
  end)

  eq(setup_called, false)
  eq(created_autocmd.event, "VimEnter")
  eq(created_autocmd.opts.once, true)

  created_autocmd.opts.callback()

  eq(setup_called, true)
end

T["copilot.lua trusts the auth file before setup when needed"] = function()
  helpers.track_editor_state({
    modules = { "copilot" },
  })

  local auth_path = "/test-config/github-copilot/apps.json"
  local trust_path = "/test-state/trust"
  local trusted_opts
  local loaded_bufnr
  local deleted_bufnr
  local setup_called = false
  local original_is_loaded
  local original_is_valid
  local original_buf_delete

  with_copilot_auth_env("/test-config", function()
    helpers.stub(vim.fn, "filereadable", function(path)
      eq(path, auth_path)
      return 1
    end)
    helpers.stub(vim.fn, "stdpath", function(kind)
      eq(kind, "state")
      return "/test-state"
    end)
    helpers.stub(vim.fn, "sha256", function(contents)
      eq(contents, '{"oauth_token":"token"}')
      return "auth-hash"
    end)
    helpers.stub(vim.fn, "bufadd", function(path)
      eq(path, auth_path)
      return 41
    end)
    helpers.stub(vim.fn, "bufload", function(bufnr)
      loaded_bufnr = bufnr
    end)
    helpers.stub(vim.uv, "fs_realpath", function(path)
      return path
    end)
    original_is_loaded = helpers.stub(vim.api, "nvim_buf_is_loaded", function(bufnr)
      if bufnr == 41 then
        return false
      end

      return original_is_loaded(bufnr)
    end)
    original_is_valid = helpers.stub(vim.api, "nvim_buf_is_valid", function(bufnr)
      if bufnr == 41 then
        return true
      end

      return original_is_valid(bufnr)
    end)
    original_buf_delete = helpers.stub(vim.api, "nvim_buf_delete", function(bufnr, opts)
      if bufnr == 41 then
        deleted_bufnr = bufnr
        eq(opts.force, true)
        return
      end

      return original_buf_delete(bufnr, opts)
    end)
    helpers.stub(vim, "secure", {
      trust = function(opts)
        trusted_opts = opts
        return true, auth_path
      end,
    })
    helpers.stub(io, "open", function(path, mode)
      if path == auth_path and mode == "rb" then
        return {
          read = function(_, read_mode)
            eq(read_mode, "*a")
            return '{"oauth_token":"token"}'
          end,
          close = function() end,
        }
      end

      if path == trust_path and mode == "r" then
        return nil
      end

      error(string.format("unexpected io.open(%s, %s)", path, mode))
    end)

    helpers.with_module_stubs({
      copilot = {
        setup = function()
          setup_called = true
        end,
      },
    }, function()
      dofile("vim/plugin/copilot.lua")
    end)
  end)

  eq(trusted_opts.action, "allow")
  eq(trusted_opts.bufnr, 41)
  eq(loaded_bufnr, 41)
  eq(deleted_bufnr, 41)
  eq(setup_called, true)
end

T["copilot.lua skips setup when the auth file is denied in trust"] = function()
  helpers.track_editor_state({
    modules = { "copilot" },
  })

  local messages = helpers.track_notify()
  local auth_path = "/test-config/github-copilot/apps.json"
  local trust_path = "/test-state/trust"
  local setup_called = false
  local trust_called = false

  with_copilot_auth_env("/test-config", function()
    helpers.stub(vim.fn, "filereadable", function(path)
      eq(path, auth_path)
      return 1
    end)
    helpers.stub(vim.fn, "stdpath", function(kind)
      eq(kind, "state")
      return "/test-state"
    end)
    helpers.stub(vim.uv, "fs_realpath", function(path)
      return path
    end)
    helpers.stub(vim, "secure", {
      trust = function()
        trust_called = true
      end,
    })
    helpers.stub(io, "open", function(path, mode)
      if path == trust_path and mode == "r" then
        local lines = { "! " .. auth_path }
        local index = 0

        return {
          lines = function()
            return function()
              index = index + 1
              return lines[index]
            end
          end,
          close = function() end,
        }
      end

      if path == auth_path and mode == "rb" then
        return {
          read = function()
            return '{"oauth_token":"token"}'
          end,
          close = function() end,
        }
      end

      error(string.format("unexpected io.open(%s, %s)", path, mode))
    end)

    helpers.with_module_stubs({
      copilot = {
        setup = function()
          setup_called = true
        end,
      },
    }, function()
      dofile("vim/plugin/copilot.lua")
    end)
  end)

  eq(setup_called, false)
  eq(trust_called, false)
  eq(#messages, 1)
  eq(messages[1].level, vim.log.levels.WARN)
  eq(messages[1].message, "[Copilot.lua] Skipping setup because /test-config/github-copilot/apps.json is denied in :trust")
end

return T
