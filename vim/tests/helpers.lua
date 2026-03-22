local Helpers = {}

Helpers.expect = vim.deepcopy(MiniTest.expect)

Helpers.expect.match = MiniTest.new_expectation("string matching", function(value, pattern)
  return type(value) == "string" and value:find(pattern) ~= nil
end, function(value, pattern)
  return string.format("Pattern: %s\nObserved string: %s", vim.inspect(pattern), vim.inspect(value))
end)

Helpers.new_child_neovim = function()
  local child = MiniTest.new_child_neovim()

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
