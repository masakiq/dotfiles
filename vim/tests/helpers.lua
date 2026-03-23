local Helpers = {}
local keymap_modes = { "n", "v", "x", "i", "t", "o", "c", "s" }

Helpers.expect = vim.deepcopy(MiniTest.expect)

Helpers.expect.match = MiniTest.new_expectation("string matching", function(value, pattern)
  return type(value) == "string" and value:find(pattern) ~= nil
end, function(value, pattern)
  return string.format("Pattern: %s\nObserved string: %s", vim.inspect(pattern), vim.inspect(value))
end)

Helpers.new_child_neovim = function()
  local child = MiniTest.new_child_neovim()
  local repo_root = vim.fn.getcwd()

  local function prevent_hanging(method)
    if not child.is_blocked() then
      return
    end

    error(string.format("Can not use `child.%s` because child process is blocked.", method))
  end

  child.setup = function(args)
    local full_args = { "-u", "vim/scripts/minimal_init.lua" }
    vim.list_extend(full_args, args or {})
    child.restart(full_args)
    child.lua(
      [[
      _G.dotfiles_test_repo_root = ...
      _G.dotfiles_test_originals = {
        os_execute = os.execute,
        os_getenv = os.getenv,
        vim_notify = vim.notify,
        vim_schedule = vim.schedule,
        vim_ui_select = vim.ui.select,
        vim_uv_fs_stat = vim.uv.fs_stat,
        vim_api_nvim_exec2 = vim.api.nvim_exec2,
        vim_api_nvim_get_runtime_file = vim.api.nvim_get_runtime_file,
        vim_fn_expand = vim.fn.expand,
        vim_fn_executable = vim.fn.executable,
        vim_fn_has = vim.fn.has,
        vim_fn_setreg = vim.fn.setreg,
        vim_lsp_start = vim.lsp.start,
        vim_lsp_get_client_by_id = vim.lsp.get_client_by_id,
      }
    ]],
      { repo_root }
    )
  end

  child.reset = function()
    prevent_hanging("reset")

    child.lua([[
      local originals = _G.dotfiles_test_originals or {}

      os.execute = originals.os_execute or os.execute
      os.getenv = originals.os_getenv or os.getenv
      vim.notify = originals.vim_notify or vim.notify
      vim.schedule = originals.vim_schedule or vim.schedule
      vim.ui.select = originals.vim_ui_select or vim.ui.select
      vim.uv.fs_stat = originals.vim_uv_fs_stat or vim.uv.fs_stat
      vim.api.nvim_exec2 = originals.vim_api_nvim_exec2 or vim.api.nvim_exec2
      vim.api.nvim_get_runtime_file = originals.vim_api_nvim_get_runtime_file or vim.api.nvim_get_runtime_file
      vim.fn.expand = originals.vim_fn_expand or vim.fn.expand
      vim.fn.executable = originals.vim_fn_executable or vim.fn.executable
      vim.fn.has = originals.vim_fn_has or vim.fn.has
      vim.fn.setreg = originals.vim_fn_setreg or vim.fn.setreg
      vim.lsp.start = originals.vim_lsp_start or vim.lsp.start
      vim.lsp.get_client_by_id = originals.vim_lsp_get_client_by_id or vim.lsp.get_client_by_id

      for _, mode in ipairs({ "n", "v", "x", "i", "t", "o", "c", "s" }) do
        for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
          pcall(vim.api.nvim_del_keymap, mode, map.lhs)
        end
      end

      for name in pairs(vim.api.nvim_get_commands({ builtin = false })) do
        pcall(vim.api.nvim_del_user_command, name)
      end

      for _, autocmd in ipairs(vim.api.nvim_get_autocmds({})) do
        pcall(vim.api.nvim_del_autocmd, autocmd.id)
      end

      for name, _ in pairs(package.loaded) do
        if name:match("^commands%.")
          or name:match("^config%.")
          or name:match("^pickers%.")
          or name:match("^selectors%.")
          or name:match("^telescope")
          or name == "lazy"
          or name == "rubocop"
          or name == "search_word"
        then
          package.loaded[name] = nil
        end
      end

      for name, _ in pairs(_G) do
        if name:match("^phase%d")
          or name:match("^lazy_")
          or name:match("^init_")
          or name:match("^last_")
          or name:match("^picker_")
          or name:match("^selected_")
          or name:match("^visual_")
          or name:match("^normal_")
          or name:match("^callback_")
          or name:match("^command_")
          or name == "notifications"
          or name == "select_called"
          or name == "select_labels"
          or name == "M"
        then
          _G[name] = nil
        end
      end

      vim.g.dotfiles_lazy_setup_complete = nil

      pcall(vim.cmd, "silent! cclose")
      pcall(vim.cmd, "silent! lclose")
      pcall(vim.cmd, "silent! tabonly")
      pcall(vim.cmd, "silent! only")
      pcall(vim.cmd, "silent! %bwipeout!")
      vim.cmd("enew!")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
      vim.bo.filetype = ""
      vim.bo.syntax = ""
      vim.bo.modified = false
      vim.cmd("lcd " .. vim.fn.fnameescape(_G.dotfiles_test_repo_root))
      vim.fn.setqflist({})
      vim.fn.setloclist(0, {})
      vim.diagnostic.reset()
    ]])
  end

  child.set_lines = function(lines, start, finish)
    prevent_hanging("set_lines")

    if type(lines) == "string" then
      lines = vim.split(lines, "\n", { plain = true })
    end

    child.api.nvim_buf_set_lines(0, start or 0, finish or -1, false, lines)
  end

  child.get_lines = function(start, finish)
    prevent_hanging("get_lines")
    return child.api.nvim_buf_get_lines(0, start or 0, finish or -1, false)
  end

  child.set_cursor = function(line, column, winid)
    prevent_hanging("set_cursor")
    child.api.nvim_win_set_cursor(winid or 0, { line, column })
  end

  child.get_cursor = function(winid)
    prevent_hanging("get_cursor")
    return child.api.nvim_win_get_cursor(winid or 0)
  end

  child.wait = function(ms)
    prevent_hanging("wait")
    child.lua("vim.wait(...)", { ms or 20 })
  end

  return child
end

local function snapshot_keymaps()
  local snapshot = {}

  for _, mode in ipairs(keymap_modes) do
    snapshot[mode] = {}

    for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
      snapshot[mode][map.lhs] = true
    end
  end

  return snapshot
end

local function snapshot_commands()
  local snapshot = {}

  for name in pairs(vim.api.nvim_get_commands({ builtin = false })) do
    snapshot[name] = true
  end

  return snapshot
end

local function snapshot_autocmds()
  local snapshot = {}

  for _, autocmd in ipairs(vim.api.nvim_get_autocmds({})) do
    if autocmd.id ~= nil then
      snapshot[autocmd.id] = true
    end
  end

  return snapshot
end

local function snapshot_buffers()
  local snapshot = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    snapshot[buf] = true
  end

  return snapshot
end

local function snapshot_options(names, getter)
  local snapshot = {}

  for _, name in ipairs(names or {}) do
    snapshot[name] = vim.deepcopy(getter(name))
  end

  return snapshot
end

local function snapshot_globals(names)
  local snapshot = {}

  for _, name in ipairs(names or {}) do
    snapshot[name] = vim.deepcopy(vim.g[name])
  end

  return snapshot
end

local function snapshot_lua_globals(names)
  local snapshot = {}

  for _, name in ipairs(names or {}) do
    snapshot[name] = _G[name]
  end

  return snapshot
end

local function snapshot_loaded_modules(names)
  local snapshot = {}

  for _, name in ipairs(names or {}) do
    snapshot[name] = package.loaded[name]
  end

  return snapshot
end

Helpers.stub = function(target, key, value)
  local original = target[key]
  target[key] = value

  MiniTest.finally(function()
    target[key] = original
  end)

  return original
end

Helpers.track_editor_state = function(opts)
  opts = opts or {}

  local state = {
    cwd = vim.fn.getcwd(),
    current_buf = vim.api.nvim_get_current_buf(),
    keymaps = snapshot_keymaps(),
    commands = snapshot_commands(),
    autocmds = snapshot_autocmds(),
    buffers = snapshot_buffers(),
    options = snapshot_options(opts.options, function(name)
      return vim.opt[name]:get()
    end),
    window_options = snapshot_options(opts.window_options, function(name)
      return vim.wo[name]
    end),
    globals = snapshot_globals(opts.globals),
    lua_globals = snapshot_lua_globals(opts.lua_globals),
    loaded_modules = snapshot_loaded_modules(opts.modules),
  }

  MiniTest.finally(function()
    for _, mode in ipairs(keymap_modes) do
      for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
        if not state.keymaps[mode][map.lhs] then
          pcall(vim.api.nvim_del_keymap, mode, map.lhs)
        end
      end
    end

    for name in pairs(vim.api.nvim_get_commands({ builtin = false })) do
      if not state.commands[name] then
        pcall(vim.api.nvim_del_user_command, name)
      end
    end

    for _, autocmd in ipairs(vim.api.nvim_get_autocmds({})) do
      if autocmd.id ~= nil and not state.autocmds[autocmd.id] then
        pcall(vim.api.nvim_del_autocmd, autocmd.id)
      end
    end

    pcall(vim.cmd, "silent! cclose")
    pcall(vim.cmd, "silent! lclose")
    pcall(vim.cmd, "silent! tabonly")
    pcall(vim.cmd, "silent! only")

    if state.current_buf and vim.api.nvim_buf_is_valid(state.current_buf) then
      pcall(vim.api.nvim_set_current_buf, state.current_buf)
    else
      pcall(vim.cmd, "enew!")
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if not state.buffers[buf] and vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end

    for name, value in pairs(state.options) do
      vim.opt[name] = value
    end

    for name, value in pairs(state.window_options) do
      vim.wo[name] = value
    end

    for name, value in pairs(state.globals) do
      vim.g[name] = value
    end

    for name, value in pairs(state.lua_globals) do
      _G[name] = value
    end

    for name, value in pairs(state.loaded_modules) do
      package.loaded[name] = value
    end

    vim.cmd("lcd " .. vim.fn.fnameescape(state.cwd))
    vim.fn.setqflist({})
    vim.fn.setloclist(0, {})
    vim.diagnostic.reset()
  end)

  return state
end

Helpers.with_module_stubs = function(stubs, callback)
  local originals = {}

  for name, value in pairs(stubs) do
    originals[name] = package.loaded[name]
    package.loaded[name] = value
  end

  MiniTest.finally(function()
    for name, value in pairs(originals) do
      package.loaded[name] = value
    end
  end)

  return callback()
end

Helpers.reload_module = function(name)
  package.loaded[name] = nil
  MiniTest.finally(function()
    package.loaded[name] = nil
  end)

  return require(name)
end

Helpers.require_with_stubs = function(name, stubs)
  return Helpers.with_module_stubs(stubs or {}, function()
    return Helpers.reload_module(name)
  end)
end

Helpers.make_scratch_buffer = function(lines, name)
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_current_buf(buf)

  if name then
    vim.api.nvim_buf_set_name(buf, name)
  end

  if lines then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end

  MiniTest.finally(function()
    if vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end)

  return buf
end

Helpers.track_notify = function()
  local messages = {}
  local original = vim.notify

  vim.notify = function(message, level, opts)
    table.insert(messages, {
      message = message,
      level = level,
      opts = opts,
    })
  end

  MiniTest.finally(function()
    vim.notify = original
  end)

  return messages
end

return Helpers
